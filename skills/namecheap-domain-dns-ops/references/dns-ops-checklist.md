# Namecheap DNS Ops Checklist

## Control Plane

- registrar and DNS host are distinguished
- it is clear whether DNS changes belong in Namecheap or elsewhere

## Records

- apex and `www` behavior are explicit
- verification, email, and certificate records are accounted for
- nameserver changes and host-record changes are not confused

## Rollout

- cutover risks are visible
- the next DNS step is explicit
