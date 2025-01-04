import 'dart:io';

void main(List<String> args) async {
  final channel = await WebSocket.connect(
    'ws://localhost:8000/api/v1/notifications/new/snapshot',
    headers: {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU5ODU0MTUsImlkIjoiMGY3YjJmMTctNWE2Yi00OGIyLWE2OGQtODk1NTg4YTRkODViIiwiaXNfYWRtaW4iOmZhbHNlfQ.2tpMY7pjNo_AaLYl8jyepUMVdLdZKwoTTaUyB1y1mJ4"
    }
  );

  channel.listen((data) {
    print(data);
  });
}