"""
A simple example demonstrating basic Spark SQL features.
Run with:
  ./bin/spark-submit spark_submitter.py
"""
import json
import pathlib
import sys
import urllib.parse
from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.types import StringType, StructType, StructField


def create_view(spark, view_name, source):
    # spark is an existing SparkSession
    format = pathlib.Path(source).suffix[1:]
    df = spark.read.load(source, format=format)
    # df.show()
    # df.printSchema()

    # Register the DataFrame as a SQL temporary view
    df.createOrReplaceTempView(view_name)

    # # Register the DataFrame as a global temporary view
    # df.createGlobalTempView("people")
    # # Global temporary view is tied to a system preserved database `global_temp`
    # spark.sql("SELECT * FROM global_temp.people").show()

if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Python Spark SQL basic example") \
        .getOrCreate()
        # .config("spark.some.config.option", "some-value") \

    json_string = urllib.parse.unquote(str(sys.argv[1]))
    payload = json.loads(json_string)

    for view in payload["views"]:
        # print (view)
        create_view(spark, view["name"], view["source"])
    
    for sql_query in payload["queries"]:
        print (sql_query)
        sqlDF = spark.sql(sql_query)
        sqlDF.show()

    spark.stop()
