# Port scan

Correct as of 3rd June 2004.

Scan was to and from telstar, so should be unaffected by any machine-specific rules, since it's unlikely to have any.

Outbound, filtered: (assume the rest are open)

1-1023, 1214, 2000, 2049, 4444, 6000, 6257, 6346, 6699, 8888, 9001, 9002, 36794

Inbound, open: (assume the rest are filtered)

20, 21, 22, 23, 80, 109, 110, 143, 443, 993, 1196, 1579, 2287, 2655, 3219, 5100, 6667, 7001

UDP, Outbound, filtered:

1-1023, 1080, 2002, 2049, 3130, 4444, 4591, 4666, 4728, 6346, 6699, 8888, 9002, 10000, 18671

UDP, Inbound, open:

Not a single sausage.
