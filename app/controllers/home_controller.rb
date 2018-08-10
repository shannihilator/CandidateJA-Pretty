class HomeController < ApplicationController
  # Level 1
  def index
    
    # Initialize variables to be arrays
    @first_name = Array.new
    @email_address = Array.new
    @title = Array.new

    # Gets body of API call and initializes first name, email, and job title
    call(@first_name, @email_address, @title)
 
  end

  # Level 2
  def displayFreq
    
    #Define a hash for the frequencies
    @frequency = Hash.new(0)

    # Initialize variables to be arrays
    @first_name = Array.new
    @email_address = Array.new
    @title = Array.new

    # Gets body of API call and initializes first name, email, and job title
    call(@first_name, @email_address, @title)

    #Iterate over each character and put them in to the hash
    @email_address.each do |email|
      email = email.split('')
      email.each do |e|
        @frequency[e] += 1
      end
    end

    #Sort in descending order
    @frequency = @frequency.sort_by {|_key, value| value}.reverse
  end


  # Level 3

  def displayDup

    # Initialize variables to be arrays
    @first_name = Array.new
    @email_address = Array.new
    @title = Array.new

    # Gets body of API call and initializes first name, email, and job title
    call(@first_name, @email_address, @title)

    #all data combined
    
    @dups = @first_name.group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)
    @data = @first_name.zip(@email_address, @title)
    @data.each 

  end



  #Helper Funcitons

  # Funciton to initialize variables
  def call(first_name, email_address, title)

    # Call SalesLoft API and get the body of the response
    @body = salesApi()

    # Funnel JSON into appropiate variable
    @body.each do |body|
      first_name << body['first_name']
      email_address << body['email_address']
      title << body['title']
    end
  end
  

  # Makes call to SalesLoft API
  def salesApi
    require 'uri'
    require 'net/http'
    require 'json'

    #Arrays for each category
    
    @frequency = Hash.new(0)

    url = URI("https://api.salesloft.com/v2/people.json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = 'Bearer ' + ENV["API_KEY"]

    response = http.request(request)
    
    @body = JSON.parse(response.body)['data']
    return @body
  end
end
