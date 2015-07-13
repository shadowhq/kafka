import sys
from kafka import SimpleProducer, KafkaClient

# ip address
ip = sys.argv[1]
port = 9092
address = '%s:%s' % (ip, port)

print address

# To send messages synchronously
kafka = KafkaClient(address)
producer = SimpleProducer(kafka)

while True:
    input = sys.stdin.readline()
    producer.send_messages(b'my-topic', input)
