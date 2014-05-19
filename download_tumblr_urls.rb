# ================ LIBRARIES ================

require 'httparty'
require 'uri'

# ================ CONSTANTS ================

DEFAULT_URLS_LIST  = "url.txt"
IMAGE_FOLDER_NAME  = "tumblr"

IMG_SIZES          = ["1280","500","400","250"]
TUMBLR_IMG_PATTERN = /\A(?<base>.*)\/(?<stem>.*)_(?<size>.*)\.(?<extension>.*)\Z/

# ================ FUNCTIONS ================

def download_tumblr_image(url)
  url = TUMBLR_IMG_PATTERN.match(url)

  url_base = url[:base]
  url_stem = url[:stem]
  url_ext  = url[:extension]

  IMG_SIZES.each do |size|
    query_filename = url_stem + "_" + size + "." + url_ext
    query_url = url_base + "/" + query_filename

    response = HTTParty.get(query_url)

    if response.headers["content-type"].include?("image")
      File.open(IMAGE_FOLDER_NAME + "/" + query_filename, "wb") do |f|
        f.write(response.body)
      end

      break
    end
  end
end

def concat_lines_from_files(files)
  lines = Array.new

  files.each do |file|
    if File.file?(file)
      puts "=== CONCATENATING #{file} ==="

      File.foreach(file) do |line|
        lines << line.chomp
      end
    else
      puts "=== #{file} IS INVALID ==="
    end
  end

  return lines
end

def sanitize_tumblr_urls(urls)
  urls = urls.reject do |url|
    url !~ /\A#{URI::regexp}\z/ || # invalid urls (including blank lines)
    !url.include?("tumblr")     || # non-tumblr links
    url.include?("avatar")      || # tumblr avatars
    url.include?("assets")         # tumblr assets
  end

  return urls.uniq
end

# ================ MAIN ================

Dir::mkdir(IMAGE_FOLDER_NAME) unless File.exists?(IMAGE_FOLDER_NAME)

files = ARGV.empty? ? [DEFAULT_URLS_LIST] : ARGV
urls = concat_lines_from_files(files)
urls = sanitize_tumblr_urls(urls)

count = urls.count
degree = count.to_s.length

urls.each_with_index do |url, index|
  puts "#{(index + 1).to_s.rjust(degree, "0")} of #{count}: #{url}"
  download_tumblr_image(url)
end
