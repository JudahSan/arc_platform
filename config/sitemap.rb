# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://rubycommunity.africa"
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  add '/about_us',
    changefreq: 'monthly',
    priority: 0.9
  add '/learn',
    changefreq: 'monthly',
    priority: 0.9
  add '/chapters',
    changefreq: 'monthly',
    priority: 0.9

  Chapter.find_each do |chapter|
    add chapter_path(chapter), :lastmod => chapter.updated_at
  end

  add '/users/sign_up',
    changefreq: 'monthly',
    priority: 0.8
  
  add '/users/sign_in',
    changefreq: 'monthly',
    priority: 0.8
end
