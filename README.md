# ArticleCrux

The gem scrapes HTML of a URL and returns the title and cover image which most likey represents the article. It also returns an array of tags. The gem can be useful in scenarios where you want to display a short summary of the article, before the end-user lands on the actual article. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'article_crux'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install article_crux

## Usage
<pre lang="ruby"><code>
require 'article_crux'

ArticleCrux.fetch("https://techcrunch.com/2017/04/18/facebook-announces-react-fiber-a-rewrite-of-its-react-framework/")
=> {:image=>"https://tctechcrunch2011.files.wordpress.com/2017/04/image-uploaded-from-ios-1.jpg?w=764&h=400&crop=1", :title=>"Facebook announces React Fiber, a rewrite of its React framework", :tags=>["developers", "F82017", "Facebook", "Javascript", "react", "React Fiber"]}

# In case you want to pass a custom user Agent (server can whitelist specific User agents, as well as you might me blocked, and at times a server might return a different for different user agent)
user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:10.0) Gecko/20100101 Firefox/10.0"
ArticleCrux.fetch("https://techcrunch.com/2017/04/18/facebook-announces-react-fiber-a-rewrite-of-its-react-framework/", user_agent)
=> {:image=>"https://tctechcrunch2011.files.wordpress.com/2017/04/image-uploaded-from-ios-1.jpg?w=764&h=400&crop=1", :title=>"Facebook announces React Fiber, a rewrite of its React framework", :tags=>["developers", "F82017", "Facebook", "Javascript", "react", "React Fiber"]}
</code></pre>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amitsaxena/article_crux.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


