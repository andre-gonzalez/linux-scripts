from databricks.connect import DatabricksSession
from databricks.sdk.core import Config
from IPython.display import display
config = Config(profile = "DEFAULT")
spark = DatabricksSession.builder.sdkConfig(config).getOrCreate()
dbutils = DBUtils(spark)
