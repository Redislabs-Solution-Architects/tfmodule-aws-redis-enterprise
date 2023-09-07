cat outit.json| jq '.[] | select(.module_name=="ReJSON") | .semantic_version'
