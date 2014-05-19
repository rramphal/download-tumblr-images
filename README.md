## Download Tumblr Images
###### Ravi S. Rāmphal // 2013.04.07 // Refactored 2014.05.18

***

### Description

This is a ruby script that allows you to download that highest resolution versions of a list of Tumblr images. You can feed one or more lists of Tumblr image URLs in plain text format with each URL on its own line. It will ignore avatars, and Tumblr assets (images used for Tumblr UX and not actually content).

The default case expects that you have put the urls in a file called `url.txt`. You simply call the script with:

```bash
ruby download_tumblr_urls.rb
```

However, if you would like to provide a different file(s), you can specify it/them like this:

```bash
ruby download_tumblr_urls.rb list1.txt list2.txt
```

It will download into a folder in the same directory as the script file called "tumblr," but you can change this by opening up the script and changing the `IMAGE_FOLDER_NAME` constant. You can also change the default filename by changing the `DEFAULT_FILE` constant.

***

### Reflection

While the code is split out into readable units (functions with single responsibilities), they are coupled with constants. I am not sure what best practice is in this case.

***

### Notes

#### # vs .

These are naming conventions in Ruby in documentation.

`#` refers to class methods  
`.` refers to instance methods

For example: `File#file?` -- or -- `array.each`

#### ARGV vs. ARGF

I use `ARGV` here, but I could have adapted this to use `ARGF`. `ARGF` reads in the contents of files passed into a stream that you can iterate through. However, it would have been more difficult to set a default file to read in.

<http://robm.me.uk/ruby/2013/12/03/argf-ruby.html>

#### Testing ARGV

```ruby
files =           ARGV.empty? ? [DEFAULT_FILE] : ARGV
# refactored for single responsibility
files = array_of_files.empty? ? [DEFAULT_FILE] : array_of_files
```

With this ternary expression, I test `ARGV` and conditionally store it. If `ARGV` is empty (i.e., if no parameters were passed to the script), then set files equal to the default file name defined as a constant above wrapped in an array. Else, set files equal to the list of parameters passed in. Note that files will always be an array.

#### Testing the existence of a file (and file? vs. exist?)

```ruby
if File.file?(file)
```

Here, we use `#file?` from the `File` class to test if the file `file` exists and is a regular file. It will return `true` if it is and `false` if it is not. 

We do not use `#exist?` because it will return `true` for both existing files *and* directories.

The following code makes use of this:

```ruby
Dir::mkdir(IMAGE_FOLDER_NAME) unless File.exists?(IMAGE_FOLDER_NAME)
```

<http://www.gethourglass.com/blog/ruby-check-if-file-exists.html>

#### for loops vs. .each loops

I normally use `for item in items` which I thought was identical to `items.each do |item|`. However, I found out that there is a subtle difference in variable scoping.

When using the `for` loop, variables local to the loop are accessible from outside the loop. This includes the placeholder variable (in this case, `item` — technically, the parameter for the block), which is equal to `items.last`.

On the other hand, when you use the `.each` loop, variables local to the loop, including the placeholder variable, is remains scoped within the loop and are undefined outside of the loop.

<http://stackoverflow.com/questions/155462/what-is-for-in-ruby>

**for**
```ruby
items = [1, 2, 3, 4]

for item in items
  data = item
end

p data #=> "4"
p item #=> "4"
```

**.each**
```ruby
items = [1, 2, 3, 4]

items.each do |item|
  data = item
end

p data #=> NameError: undefined local variable or method `data' for main:Object
p item #=> NameError: undefined local variable or method `item' for main:Object
```

***

### Old Python code

```python
# =========== LIBRARIES ===========

import re
import os
import subprocess

# =========== CUSTOMIZE ===========

urlsfile = "url.txt" # a text file with each tumblr image link on its own line
wgetfile = "\"C:\\Users\\Ravi\\Documents\\School Work\\Resources\\Tools\\wget.exe\"" #wget location

# =========== CONSTANTS ===========

img_sizes = ["1280","500","400","250"]
tumblr_img_pattern = "(.*)_(.*)\.(.*)"

# =========== FUNCTIONS ===========

def dl_tumblr_img(url):
  
  url = re.search(tumblr_img_pattern, url)
  
  urlstem = url.group(1)
  urlext = url.group(3)
  
  for size in img_sizes:
    cmd = subprocess.Popen(wgetfile + " " + urlstem + "_" + size + "." + urlext, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stop = True
    for line in cmd.stdout:
      if "403" in line.decode("utf-8"):
        stop = False
    if stop:
      return
      
# =========== PROGRAM ===========

file = open(urlsfile, 'r')
urls = file.readlines()
file.close()

counter = 1;
num_urls = str(len(urls))

for url in urls:
  print(str(counter) + " of " + num_urls + ": " + url)
  counter += 1
  dl_tumblr_img(url)
```
