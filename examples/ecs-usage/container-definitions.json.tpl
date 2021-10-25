${jsonencode([{
  "name": "ecs-config-files-example",
  "image": "${image_name}:${image_version}",
  "cpu": 256,
  "memory": 512,
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-region": "${region}",
      "awslogs-group": "ecs-config-files-example",
      "awslogs-stream-prefix": "complete-ecs"
    }
  },
  "secrets": [for k, v in files : { "name": "${k}", "valueFrom": "${v}" }],
}])}
