-- Insert host hardware specifications
INSERT INTO host_info (
    hostname,
    cpu_number,
    cpu_architecture,
    cpu_model,
    cpu_mhz,
    l2_cache,
    timestamp,
    total_mem
) VALUES (
    <hostname>,
    <cpu_number>,
    <cpu_architecture>,
    <cpu_model>,
    <cpu_mhz>,
    <l2_cache>,
    <timestamp>,
    <total_mem>
);

-- Insert collected values for host usage
INSERT INTO host_usage (
    timestamp,
    host_id,
    memory_free,
    cpu_idle,
    cpu_kernel,
    disk_io,
    disk_available
) VALUES (
    <timestamp>,
    <host_id>,
    <memory_free>,
    <cpu_idle>,
    <cpu_kernel>,
    <disk_io>,
    <disk_available>
);