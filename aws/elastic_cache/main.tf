resource "aws_elasticache_serverless_cache" "serverless-memory-db" {
  engine = var.engine_name
  name   = var.name
  cache_usage_limits {
    data_storage {
      maximum = var.max_data_storage
      unit    = var.max_data_storage_unit
    }
    ecpu_per_second {
      maximum = var.ecpu_per_second
    }
  }
  daily_snapshot_time      = var.daily_snapshot_time
  description              = var.description
  major_engine_version     = var.major_engine_version
  snapshot_retention_limit = var.snapshot_retention_limit
  security_group_ids       = var.security_group_ids
  subnet_ids               = var.subnet_id
}