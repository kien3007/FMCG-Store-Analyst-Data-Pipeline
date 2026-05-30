import pandas as pd
from sqlalchemy import create_engine, text
import os

# Supabase local Postgres connection string
# Default user: postgres, password: postgres, port: 54322, db: postgres
DATABASE_URI = 'postgresql://postgres:postgres@localhost:54322/postgres'

def load_data():
    pass # Replaced by run() below

if __name__ == '__main__':
    def run():
        print("Connecting to Supabase Local Database...")
        engine = create_engine(DATABASE_URI)
        
        # Create the schema first if it doesn't exist.
        # Use sqlalchemy.text() for SQLAlchemy 2.0 compatibility
        with engine.connect() as conn:
            conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw;"))
            conn.commit()
            
        base_dir = 'datasets'
        if not os.path.exists(base_dir):
            base_dir = '../datasets'
            
        files = ['categories.csv', 
                 'cities.csv', 
                 'countries.csv', 
                 'employees.csv', 
                 'products.csv', 
                 'customers.csv', 
                 'sales.csv']
        
        for file in files:
            file_path = os.path.join(base_dir, file)
            table_name = file.replace('.csv', '')
            if os.path.exists(file_path):
                print(f"Loading {file} into raw.{table_name}...")
                chunksize = 100000 if file == 'sales.csv' else None
                if chunksize:
                    for i, chunk in enumerate(pd.read_csv(file_path, chunksize=chunksize)):
                        chunk.to_sql(table_name, engine, schema='raw', if_exists='replace' if i == 0 else 'append', index=False)
                        print(f"  Loaded chunk {i+1}")
                else:
                    df = pd.read_csv(file_path)
                    df.to_sql(table_name, engine, schema='raw', if_exists='replace', index=False)
                print(f"Loaded {file} successfully.")
            else:
                print(f"Warning: {file_path} not found.")
                
    run()
