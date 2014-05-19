## Download Tumblr Images
###### Ravi S. Rāmphal // 2013.04.07

### # vs .

These are naming conventions in Ruby.

`#` refers to class methods  
`.` refers to instance methods

For example:

File#file?
array.each

### ARGV vs. ARGF

I use `ARGV` here, but I could have adapted this to use `ARGF`. `ARGF` reads in the contents of files passed into a stream that you can iterate through. However, it would have been more difficult to set a default file to read in.

See <http://robm.me.uk/ruby/2013/12/03/argf-ruby.html> for more information.

### Testing ARGV

```ruby
files = ARGV.empty? ? [DEFAULT_FILE] : ARGV
```

With this ternary expression, I test `ARGV` and conditionally store it. If `ARGV` is empty (i.e., if no parameters were passed to the script), then set files equal to the default file name defined as a constant above wrapped in an array. Else, set files equal to the list of parameters passed in. Note that files will always be an array.

### Testing the existence of a file (and file? vs. exists?)

```ruby
if File.file?(file)
```

Here, we use `#file?` from the `File` class to test if the file `file` exists and is a regular file. It will return `true` if it is and `false` if it is not. 

We do not use `#exists?` because it will return `true` for both existing files *and* directories.

### for loops vs. .each loops

I normally use `for item in items` which I thought was identical to `items.each do |item|`. However, I found out that there is a subtle difference in variable scoping.

When using the `for` loop, variables local to the loop are accessible from outside the loop. This includes the placeholder variable (in this case, `item` — technically, the parameter for the block), which is equal to `items.last`.

On the other hand, when you use the `.each` loop, variables local to the loop, including the placeholder variable, is remains scoped within the loop and are undefined outside of the loop.

See <http://stackoverflow.com/questions/155462/what-is-for-in-ruby> for more information.

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
