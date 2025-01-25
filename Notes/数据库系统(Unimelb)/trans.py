import os

def replace_text_in_file(file_path):
    # Define the replacement mapping
    replacement_map = {
        ":zero:": "**0️⃣**",
        ":one:": "**1️⃣**",
        ":two:": "**2️⃣**",
        ":three:": "**3️⃣**",
        ":four:": "**4️⃣**",
        ":five:": "**5️⃣**",
        ":six:": "**6️⃣**",
        ":seven:": "**7️⃣**",
        ":eight:": "**8️⃣**",
        ":nine:": "**9️⃣**",
    }

    # Read the file content
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except UnicodeDecodeError:
        print(f"Skipping non-text file: {file_path}")
        return

    # Apply replacements if they haven't been applied yet
    for key, value in replacement_map.items():
        if key in content:
            content = content.replace(key, value)

    # Write the modified content back to the file
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(content)
    print(f"Updated file: {file_path}")

def main():
    # Walk through all directories and files in the current directory
    for dirpath, dirnames, filenames in os.walk('.'):
        # Filter for Markdown files
        md_files = [os.path.join(dirpath, f) for f in filenames if f.endswith('.md')]
        # Process each Markdown file
        for file_name in md_files:
            replace_text_in_file(file_name)

if __name__ == "__main__":
    main()