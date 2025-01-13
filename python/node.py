import requests
import yaml
import json

# GitHub 项目的 URL
repo_url = "https://raw.githubusercontent.com/zhangkaiitugithub/passcro/main/"

# 文件列表
files = {
    "speednodes.yaml": "speednodes.yaml",
    "speednodes.txt": "speednodes.txt",
    "sing-box.json": "sing-box.json",
    "meta.yaml": "meta.yaml"
}

for file_name, file_path in files.items():
    response = requests.get(repo_url + file_name)
    if response.status_code == 200:
        with open(file_path, 'w') as f:
            if file_name.endswith('.yaml'):
                yaml.dump(yaml.safe_load(response.text), f)
            elif file_name.endswith('.json'):
                json.dump(response.json(), f, indent=4)
            else:
                f.write(response.text)
    else:
        print(f"Failed to fetch {file_name}: {response.status_code}")
