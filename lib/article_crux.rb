require "article_crux/version"
require 'httparty'
require 'nokogiri'
require 'fastimage'
require 'addressable'
require 'open-uri'

module ArticleCrux
  def self.fetch(url, user_agent="ArticleCrux(https://github.com/amitsaxena/article_crux)")
    url = (url =~ /^(http|https):\/\/(.)*/i) ? url : "http://#{url}"
    probe = HTTParty.head(url, headers: {"User-Agent" => user_agent})
    if(probe.content_type && probe.content_type.split('/')[0] == "image")
      return {:image => url, :title => nil, :tags => []}
    end
    
    begin
      res = HTTParty.get(url, headers: {"User-Agent" => user_agent})
      raise "Unable to crawl URL" if res.code != 200
      doc = Nokogiri::HTML(res)
    rescue
      doc = Nokogiri::HTML(open(url, "User-Agent" => user_agent))
    end
    
    og_url = doc.search("//meta[@property='og:url' or @name='og:url']")
    if (!og_url.empty? && !str_blank?(og_url[0]["content"]) && (og_url[0]["content"] =~ /^(http|https):\/\/(.)*/i) && (url != og_url[0]["content"]))
      begin
        res = HTTParty.get(og_url[0]["content"], headers: {"User-Agent" => user_agent})
        raise "Unable to crawl URL" if res.code != 200
        doc = Nokogiri::HTML(res)
      rescue
        # If the og:url is faulty or doesn't return a 200 response, use the original url for meta data scraping
      end
    end
    
    og_image = doc.search("//meta[@property='og:image' or @name='og:image']")
    og_images = []
    if !og_image.empty?
      og_image.each do |ogi|
        if !str_blank?(ogi["content"])
          image = ogi["content"]
          if (image =~ /^\/\/(.)*/)
            uri = URI.parse(url)
            image = "#{uri.scheme}:#{image}"
          elsif (image =~ /^\/(.)*/)
            uri = URI.parse(url)
            image = File.join("#{uri.scheme}://#{uri.host}", image)
          end
          og_images << image
        end
      end
    end

    # Try to get the best image based on heuristics
    image = get_best_image(og_images)

    # If og:image is an invalid image (or extremely small), fall back to <img> tags
    og_size = FastImage.size(Addressable::URI.escape(image)) if !str_blank?(image)
    if (str_blank?(image) || og_size.nil? || (og_size[0] < 100 && og_size[1] < 100))
      image = nil # reset image so that it doesn't show up in response
      image_paths = []
      page_images = doc.search("//img")
      page_images.each do |page_image|
        next if (str_blank?(page_image["src"]))
        clip_image = page_image["src"]
        if (clip_image && !(clip_image =~ /^(http|https):\/\/(.)*/i))
          base = doc.search("//base")[0]
          base_url = base["href"] if (!base.nil? && !str_blank?(base["href"]))
          uri = URI.parse(url)
          if (clip_image =~ /^\/(.)*/)
            base_url = "#{uri.scheme}://#{uri.host}" if str_blank?(base_url)
          else
            base_url = "#{uri.scheme}://#{uri.host}#{uri.path[%r{^(.*[\/])}]}" if str_blank?(base_url)
          end
          clip_image = File.join(base_url, clip_image)
        end
        image_paths << clip_image
      end
    end

    og_title = doc.search("//meta[@property='og:title' or @name='og:title']")
    if (!og_title.empty? && !str_blank?(og_title[0]["content"]))
      clip_title = og_title[0]["content"]
    else
      page_title = doc.search("//title")[0]
      clip_title = page_title.text if !str_blank?(page_title)
    end

    tags = []
    possible_tags = doc.xpath('//meta[contains(@name, "tag") or contains(@name, "keyword") or contains(@property, "tag") or contains(@property, "keyword")]')
    possible_tags.each{|e| tags << e["content"].split(',') if !str_blank?(e["content"])}
    tags = tags.flatten.map(&:strip).uniq

    res = {:image => image, :title => clip_title, :tags => tags}
  end
  
  def self.get_best_image(images)
    return nil if images.empty?
    return images[0] if (images.size == 1)
    # reject logo or similar images
    refined_images = images.reject{|i| i =~ /logo|fallback/i}
    return refined_images[0] if (refined_images.size == 1)
    refined_images = images if refined_images.empty?
    dimensions = []
    refined_images.each do |i|
      type = FastImage.type(Addressable::URI.escape(i))
      size = FastImage.size(Addressable::URI.escape(i))
      return i if((type == :gif) && (size && size[0] > 299 && size[1] > 199))
      dimensions << {:x => size[0], :y => size[1], :image => i} if !size.nil?
    end
    image = dimensions.empty? ? nil : dimensions.max_by{|d| d[:x]}[:image]
    return image
  end
  
  def self.str_blank?(str)
    str.nil? || str.empty?
  end
end
