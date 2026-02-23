resource "aws_route53_record" "mongodb" {
  zone_id = "Z06083563MQUI4X3GPRCP"
  name    = "mongodb-dev.saidevops.site"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
}