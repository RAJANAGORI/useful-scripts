## This code reads a list of URLs from a file, generates a wordlist for each URL using the cewl command, 
## and prints messages indicating which URL is currently 
## being processed and when the wordlist for each URL has been generated.
import os

# Open file containing URLs
with open('C:\\Users\\tnjh0y5iu7\\mywork\\targets\\CYPRESS-W001\\update.txt') as f:
    # Loop through each URL in the file
    for url in f:
        url = url.strip() # Remove newline character
        # Show which URL is being processed
        print('Generating wordlist for URL:', url)
        # Run cewl command to generate wordlist
        os.system('cewl {} -w {}.txt'.format(url, url.replace('https://', '').replace('www.', '')))
        # Print message once wordlist is generated
        print('Wordlist generated for URL:', url)
