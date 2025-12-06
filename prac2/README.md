OBJETIVO 
Configurar un despliegue automatizado nivel profesional usando Kubernetes + 
CI/CD + Infraestructura como código. 
Instrucciones 
1. Implementa un entorno completo con: 
o Kubernetes (Minikube, Kind, AKS, GKE o EKS) 
o Infraestructura como código (Terraform) para aprovisionar al menos: 
▪ 1 clúster 
▪ 1 namespace 
▪ 1 ingress controller 
o Docker para construir imágenes 
o Registro de contenedores (DockerHub o GitHub Container Registry) 
2. Pipeline CI/CD debe: 
o Construir la imagen 
o Ejecutar test unitarios y de integración 
o Crear el entorno de liberación (p. 12: “Scripts del entorno de 
liberación”) 
o Ejecutar pruebas en entorno de liberación 
o Realizar despliegue automatizado a producción 
3. Debe incluir rollback automático basado en métricas: 
o Error-rate > 2% 
o Latencia p95 > 500 ms 
4. Entrega: 
• Repositorio con el despliegue automatizado
