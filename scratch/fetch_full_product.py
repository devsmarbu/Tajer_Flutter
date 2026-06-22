import urllib.request
import urllib.parse
import json

base_url = "https://beta.tajershops.com/app-api/3.1"

def post_request(url, data=None):
    if data:
        encoded_data = urllib.parse.urlencode(data).encode('utf-8')
        req = urllib.request.Request(url, data=encoded_data, method='POST')
    else:
        req = urllib.request.Request(url, method='POST')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"Error: {e}")
        return None

detail_data = post_request(f"{base_url}/products/view/5220", {"page": 1})
if detail_data:
    with open("scratch/product_5220.json", "w") as f:
        json.dump(detail_data, f, indent=2)
    print("Fetched and saved to scratch/product_5220.json")
else:
    print("Failed to fetch.")
