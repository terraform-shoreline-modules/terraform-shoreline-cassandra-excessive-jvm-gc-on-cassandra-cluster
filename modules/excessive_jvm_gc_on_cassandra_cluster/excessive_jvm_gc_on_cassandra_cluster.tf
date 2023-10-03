resource "shoreline_notebook" "excessive_jvm_gc_on_cassandra_cluster" {
  name       = "excessive_jvm_gc_on_cassandra_cluster"
  data       = file("${path.module}/data/excessive_jvm_gc_on_cassandra_cluster.json")
  depends_on = [shoreline_action.invoke_memory_check,shoreline_action.invoke_set_heap_size]
}

resource "shoreline_file" "memory_check" {
  name             = "memory_check"
  input_file       = "${path.module}/data/memory_check.sh"
  md5              = filemd5("${path.module}/data/memory_check.sh")
  description      = "The Cassandra cluster may be running on hardware that does not meet the minimum requirements for the workload, resulting in insufficient memory resources and increased GC frequency."
  destination_path = "/agent/scripts/memory_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_heap_size" {
  name             = "set_heap_size"
  input_file       = "${path.module}/data/set_heap_size.sh"
  md5              = filemd5("${path.module}/data/set_heap_size.sh")
  description      = "Adjust JVM heap size: Increasing the heap size of the JVM running on the Cassandra cluster can help reduce the frequency of GC events. This can be done by configuring the JVM parameters."
  destination_path = "/agent/scripts/set_heap_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_memory_check" {
  name        = "invoke_memory_check"
  description = "The Cassandra cluster may be running on hardware that does not meet the minimum requirements for the workload, resulting in insufficient memory resources and increased GC frequency."
  command     = "`chmod +x /agent/scripts/memory_check.sh && /agent/scripts/memory_check.sh`"
  params      = ["PATH_TO_CASSANDRA_LOG_FILE"]
  file_deps   = ["memory_check"]
  enabled     = true
  depends_on  = [shoreline_file.memory_check]
}

resource "shoreline_action" "invoke_set_heap_size" {
  name        = "invoke_set_heap_size"
  description = "Adjust JVM heap size: Increasing the heap size of the JVM running on the Cassandra cluster can help reduce the frequency of GC events. This can be done by configuring the JVM parameters."
  command     = "`chmod +x /agent/scripts/set_heap_size.sh && /agent/scripts/set_heap_size.sh`"
  params      = ["NEW_HEAP_SIZE","NEW_HEAP_SIZE_IN_GB","PATH_TO_CASSANDRA_INSTALLATION_DIRECTORY"]
  file_deps   = ["set_heap_size"]
  enabled     = true
  depends_on  = [shoreline_file.set_heap_size]
}

