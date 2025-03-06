import requests
import json

BASE_URL = "https://api.crossref.org/"
FUNDER_URL = "funders/"
MEMBER_URL = "members/"
WORKS_URL = "works"
FUNDER_ID = "10000937"
MEMBER_ID = "14095"
AFFILIATION = "University+of+Winnipeg"

def parse_response(response):
    if(response.ok):
        return json.loads(response.content)
    else:
        response.raise_for_status

def query(url):
    return parse_response(requests.get(url))

def query_by_affiliation(affiliation):
    return query(BASE_URL + WORKS_URL + "?query.affiliation=" + affiliation)


def get_page_of_works(url, filter):
    return query(BASE_URL + url + filter + '/' + WORKS_URL)


#print(query_by_affiliation(AFFILIATION))
#print(get_page_of_works(MEMBER_URL, MEMBER_ID))

def total_results(results):
    return results['message']['total-results']

print("Total result by affiliation: ", total_results(query_by_affiliation(AFFILIATION)))

