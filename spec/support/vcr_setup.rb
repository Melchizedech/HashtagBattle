VCR.configure do |c|  
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service. 
  c.hook_into :webmock

  c.ignore_request do |request|
    request.method == :post
  end
end  