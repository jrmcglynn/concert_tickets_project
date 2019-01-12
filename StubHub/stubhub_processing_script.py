#%cd StubHub/
import stubhub_scraper
#%cd ..
import pandas as pd
import boto3
import s3fs

scraper = stubhub_scraper.StubHub_Scrape(test_mode=False, cities = ['NYC'])
scraper.get_tickets()

s3 = s3fs.S3FileSystem(anon=False)
with s3.open('concert-tickets-project/test-bucket/test_file.csv', 'w', encoding = 'utf-8') as file:
    scraper.events['events_df'].to_csv(file)


# Save dfs as CSVs
combined_df_dict = {**scraper.events, **scraper.tickets}
for key in combined_df_dict:
    df = combined_df_dict[key]
    key_splits = key.split('-')
    schema = key_splits[0]
    table_name = '-'.join(key_splits[1:])
    file_name = 'concert-tickets-project/test-bucket/{}/{}/{}.csv'.format(schema, table_name,
                                                        scraper.scrape_date)
    with s3.open(file_name,
                    'w', encoding = 'utf-8') as file:
        df.to_csv(file, index=False, encoding = 'utf-8')
    print('{} written'.format(file_name))
