# VPC 리소스
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.project_name}-igw"
  }
}

# 퍼블릭 서브넷
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-${var.project_name}-subnet-public-${var.availability_zones[count.index]}"
  }
}

# 프라이빗 서브넷
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-${var.project_name}-subnet-private-${var.availability_zones[count.index]}"
  }
}

# DB 서브넷
resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-${var.project_name}-subnet-db-${var.availability_zones[count.index]}"
  }
}

# NAT 게이트웨이용 Elastic IP
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0

  domain = "vpc"

  tags = {
    Name = "${var.environment}-${var.project_name}-eip-${var.availability_zones[count.index]}"
  }

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway (서브넷당 1ea)
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.environment}-${var.project_name}-nat-${var.availability_zones[count.index]}"
  }

  depends_on = [aws_internet_gateway.main]
}

# 퍼블릭 라우팅 테이블
resource "aws_route_table" "public" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.project_name}-rtb-public-${var.availability_zones[count.index]}"
  }
}

# 퍼블릭 서브넷의 인터넷 게이트웨이 라우팅
resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnet_cidrs)

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# 퍼블릭 서브넷 라우팅 테이블 연결
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# 프라이빗 라우팅 테이블
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.project_name}-rtb-private-${var.availability_zones[count.index]}"
  }
}

# 프라이빗 서브넷의 NAT 게이트웨이 라우팅
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[count.index].id
}

# 프라이빗 서브넷 라우팅 테이블 연결
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# DB 라우팅 테이블
resource "aws_route_table" "db" {
  count  = length(var.db_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.project_name}-rtb-db-${var.availability_zones[count.index]}"
  }
}

# DB 서브넷 라우팅 테이블 연결
resource "aws_route_table_association" "db" {
  count = length(var.db_subnet_cidrs)

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[count.index].id
}

# DB 서브넷 그룹
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-${var.project_name}-${var.service_name}-db-subnet-group"
  subnet_ids = var.environment == "dev" ? aws_subnet.public[*].id : aws_subnet.db[*].id


  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-db-subnet-group"
  }
}
