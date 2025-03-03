#!/usr/bin/env ruby
# encoding: utf-8

require 'csv'
require 'rest_client'
require 'json'

#BASE_URL = "https://api.openalex.org/works?filter=concepts.id:C58642233,has_orcid:true,publication_year:2023&per_page=50&page="
BASE_URL = "https://api.openalex.org/works?filter=authorships.institutions.lineage%3Ai872945872&page="

def get_data(page:)
   CSV.open("open_alex.csv", 'ab') do |csv|
      response = RestClient.get(BASE_URL + page.to_s)
      data = JSON.parse(response, symbolize_names: true)
      count = data[:meta][:count].to_i
      per_page = data[:meta][:per_page].to_i

      data[:results].each do |result|
         title = result[:title]
         next if title.nil?
         doi = result[:doi]
         year = result[:publication_year]
         first_author = ""
         result[:authorships].each do |author|
           if author[:author_position] == "first" then
             first_author = author[:author][:display_name]
           end
         end
         csv << [title, first_author, doi, year]
      end

      if per_page.to_i*page.to_i <= count.to_i
         get_data(page: page+1)
      else
         return
      end
   end
end

get_data(page: 1)
