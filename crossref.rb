#!/usr/bin/env ruby
# encoding: utf-8

require 'csv'
require 'rest_client'
require 'json'

BASE_URL = "https://api.crossref.org/"
FUNDER_URL = "funders/"
MEMBER_URL = "members/"
WORKS_URL = "works/"
FUNDER_ID = "100009367" 
MEMBER_ID = "14095"

def get_works(url, filter)
  RestClient.get(BASE_URL + url + filter + '/' + WORKS_URL)
end

def get_works_by_funder(funder)
  get_works(FUNDER_URL, funder)
end

def get_works_by_member(member)
  get_works(MEMBER_URL, member)
end

def display_data(results)
  puts results
end

display_data(get_works_by_member(MEMBER_ID))

#def get_data(page:)
#  CSV.open("crossref.csv", 'ab') do |csv|
#      response = RestClient.get(BASE_URL + "funders/" + FUNDER_ID)
#     
#      response = RestClient.get(BASE_URL + "members/" + MEMBER_ID + "/works")
#      puts response

#      response = RestClient.get(BASE_URL + FUNDER_ID + '/works')
#      puts response
#      data = JSON.parse(response, symbolize_names: true)
#      count = data[:message][:'total-results'].to_i
#      per_page = 20

#      data[:message][:items].each do |item|
#         title = item[:title]
#         doi = item[:DOI]
#         journal = item[:'short-container-title']
#         author_name = ''
#         item[:author].each do |author|
#           if author[:sequence] == "first" then
#             author_name = author[:given]+ ' ' + author[:family]
#           end
#         end
#         csv << [title, doi, journal, author_name]
#      end
#      if per_page.to_i*page.to_i <= count.to_i
#         get_data(page: page+1)
#      else
#         return
#      end
#   end
#end

#get_data(page: 1)
