import json

with open("scratch/product_5220.json") as f:
    data = json.load(f)

sections = data.get("data", {}).get("data", [])
for section in sections:
    if section.get("type") == "2": # Product Images
        content = section.get("content", [])
        print(f"Total product images: {len(content)}")
        for img in content:
            print(f"Image ID: {img.get('afile_id')}, SubID (OptionValue ID): {img.get('afile_record_subid')}, URL: {img.get('product_image_url')}")
