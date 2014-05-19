# ================ LIBRARIES ================

require 'httparty'

# ================ CONSTANTS ================

DEFAULT_FILE       = "url.txt"
IMG_SIZES          = ["1280","500","400","250"]
TUMBLR_IMG_PATTERN = /\A(?<base>.*)\/(?<stem>.*)_(?<size>.*)\.(?<extension>.*)\Z/
IMAGE_FOLDER_NAME  = "tumblr"

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

# ================ MAIN ================

files = ARGV.empty? ? [DEFAULT_FILE] : ARGV

Dir::mkdir(IMAGE_FOLDER_NAME) unless File.exists?(IMAGE_FOLDER_NAME)

urls = Array.new

files.each do |file|
  if File.file?(file)
    puts "=== LOADING: #{file} ==="

    File.foreach(file) do |line|
      urls << line
    end
  end
end

urls.each_with_index do |url, index|
  puts "#{index + 1}: #{url}"
  download_tumblr_image(url)
end
