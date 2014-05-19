# =========== LIBRARIES ===========

require 'httparty'

# =========== CONSTANTS ===========

DEFAULT_FILE       = "url.txt"
IMG_SIZES          = ["1280","500","400","250"]
TUMBLR_IMG_PATTERN = "(.*)_(.*)\.(.*)"

# =========== FUNCTIONS ===========

def dl_tumblr_img(url)
  response = HTTParty.get('https://api.stackexchange.com/2.2/questions?site=stackoverflow')
end

  # url = re.search(tumblr_img_pattern, url)

  # urlstem = url.group(1)
  # urlext = url.group(3)

  # for size in img_sizes:
  #   cmd = subprocess.Popen(wgetfile + " " + urlstem + "_" + size + "." + urlext, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  #   stop = True
  #   for line in cmd.stdout:
  #     if "403" in line.decode("utf-8"):
  #       stop = False
  #   if stop:
  #     return

# =========== MAIN ===========

files = ARGV.empty? ? [DEFAULT_FILE] : ARGV

files.each do |file|
  if File.file?(file)
    File.foreach(file).with_index do |url, url_number|
      puts "#{url_number}: #{url}"
      download_tumblr_img(url)
    end
  end
end
