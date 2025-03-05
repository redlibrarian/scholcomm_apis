#!/usr/bin/env ruby
# encoding: utf-8

require 'csv'
require 'rest_client'
require 'json'

BASE_URL = "https://api.crossref.org/"
FUNDER_URL = "funders/"
MEMBER_URL = "members/"
WORKS_URL = "works"
FUNDER_ID = "100009367" 
MEMBER_ID = "14095"
AFFILIATION = "University+of+Winnipeg"

def query_by_affiliation(affiliation)
  url = BASE_URL + WORKS_URL + "?query.affiliation=" + affiliation
  RestClient.get(url)
end

def get_page_of_works(url, filter)
  url = BASE_URL + url + filter + '/' + WORKS_URL # to page through, use &rows=<rows>&cursor=* (will get next-cursor in response)
  RestClient.get(url)
end

def get_all_works_by_funder(url, filter)
  response = get_page_of_works(url, filter)
  # count = total-results(response)
  # flesh this out with cursor pagination
end

def get_works_by_funder(funder)
  get_page_of_works(FUNDER_URL, funder)
end

def get_works_by_member(member)
  get_page_of_works(MEMBER_URL, member)
end

def display_data(results)
  data = JSON.parse(results, symbolize_names: true)
  puts data
end

def total_results(results)
  JSON.parse(results, symbolize_names: true)[:message][:'total-results']
end

#display_data(get_works_by_member(MEMBER_ID))
puts "Total result by member: " + total_results(get_page_of_works(MEMBER_URL, MEMBER_ID)).to_s
puts "Total result by affiliation: " + total_results(query_by_affiliation(AFFILIATION)).to_s

def construct_record(item)  # we can use this to build whatever records we want
       title = item[:title]
       doi = item[:DOI]
       journal = item[:'short-container-title']
       author_name = ''
       item[:author].each do |author|
         if author[:sequence] == "first" and author[:given] then
           author_name = author[:given] + ' ' + author[:family]
         end
       end
       [title, doi, journal, author_name]
end

def write_to_csv(fname, results)
  CSV.open(fname, 'wb') do |csv|
    data = JSON.parse(results, symbolize_names: true)
    data[:message][:items].each do |item|
      csv << construct_record(item)
    end
  end
end

write_to_csv("output.csv", get_works_by_member(MEMBER_ID))

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
