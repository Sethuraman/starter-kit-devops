[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${minimum_cpu_units},
    "memory": ${maximum_memory_in_mb},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${name}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${logs_stream_prefix}"
      }
    }
  }
]