$adapters = get-ciminstance win32_networkadapterconfiguration
$filteredadapters = $adapters | Where-Object {$_.IPEnabled}
$filteredadapters | format-table -autosize description,index,ipsubnet,dnsserversearchorder,dnsdomain,ipaddress