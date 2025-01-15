import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "push-notification-7073c",
              "private_key_id": "ed300316a37e60197520d5a61a85e7540c9d97c4",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQD5c5zw3H4wpE55\nCMBUDtBBhU5QfZEnVSz35KqVVSAvr3xdBcBMA761UA5ZOAIImGoAWtYCftXCZpn9\nQxhkfy0gEwSgjBD/pPYBBpnzNZNKnE3frKIC67016L/luElOXbAtohBzBl/woqfH\nrBEIAr4g5f73PsOCdJKyCmnXaT7PuLwoGR1dTG8+GLCikfDeAr2i5lMorU3QPA8j\nDndA7btFaPhIPg/7jcgUQdSIHK8IAalHiwUcSuAdfJS2yZMe4WB9tteViXc/MN/6\nmFgVoyKF1enqhY/M85BZsjlOUzYSmVdqQUe6oyfaclGm5VDUNdSUWUVAoilx1it8\nHE8MuXQ3AgMBAAECggEALDwNsQKQmASS69Ca9mz4Dh5bAFf79PscMctJWpjRT9Nx\nHLfH3VLurw1GthiB9887QNvaxm+CbWovVWNgAHYy5NSqhePAoey5OP5YL3IpL9pe\nztK4mgb+swAWg2B2E2D2vGjYPOV8/tmBIh3HmWGPIJtYZrSpC8mrN8oz8aB2pHPW\nvBYnmJkUmeguRpbVN7uyzLTVLcioBH4DZJ4nBsiWCsRTCIhPj7Q1w8WAsyH8Y9a4\nqvaf3BNAMXYEwgDblyeHQH8q4gHAFOS0QtXSxyCAe4uR6wUfW3HZq44u2wIMoUd0\nPL0siUF/FZj7RtWayZqH6GctoONzcnpIPN9rzmsMtQKBgQD//5E0Np/6GUX+PmwS\nBpzJX2VTCFXcXhC+yhK4oREOQlDh1niaMO9ACsbwg9osmRx7SM0zCqq8docCSkJx\niRdDymTq5tU3lsuVvBT8FGT+04doV5RdUt9PVHx7ANFOcyZ9iOMnIIPpsk43vBVP\n9YMpQsxTqVgLr7WDdXbepHCH3QKBgQD5dAjnS45OxWbl64qe04BJvvf87f/5Skwu\nr4q8ssrvng3Q4fme5UoTgjMJGRgmHfvCJCktuTlk5RXAENVLxMuAf5a1xgHGVax4\ndVbcLToNAalwaX7OyXxpWE2lVzaCq/Kf/HQHPPmwN2eyhW49Zg3G/5T7uPJe60sI\no1FgMrzVIwKBgDavsaUlxib3HyygyRVQtE2QQ2Tpcu4QaiNXp4gpYCtbn0ufNUQ7\nD+DubHEUuZatXpg3hR5SOQbpiw3CL09xqbahlc1YYlPtsq/Z7eGruad2KIbxrpAB\nFBMuSSk9k3jewGoww9Wn7IYPwQXG+AaMu+gkjOGSW2yjrHLYtPv6xM9BAoGACFzI\nc6CHy8I4WdrUkdB7S32YaKU94IiKF0KRPxQrU28T/X2l1ZrQKelCdrqdoaF9sBtw\nOfUspGI9oWuvCtQ1EkC0t7FEm/aBSqR8XfMyL/9vQ7J1qs78Wbe5GqLa0/SZtJ1M\n8nUr1al103k/odVK/vHQd8PSdDYlFMwMzVHGHMsCgYAJ0zssFVYk0i8fjPezNSMA\nK/3/gH5fHhD4yYLRqDHOTY8AroMCJSIDFAPazUI0dljHOjhC2/uzjuVb0RJ+XCFu\njyElZfHFKXMa4W3AuNNRuRN4oO51JM1uOZGM/gqQhuW0TDJ8bvqOKv2uzO7kDlMF\nLPZpvEO5PBTl0AFTVj6Zcg==\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-qec80@push-notification-7073c.iam.gserviceaccount.com",
              "client_id": "110863583616115302256",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qec80%40push-notification-7073c.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }



        ),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}