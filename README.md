# AQI
This app used to monitor the city Air quality values
I have used MVVM architecture 
AQHomeViewModel will have the HomeView controller required datas, such as array of City AQI values
Home will show the AQI details as city wise, and we are updating the cell color based on the AQI status
AQWebSocketManager - will connect the server through socket, for websocket we have used "Starscream"
Starscream used to connect the websocket 
View model will call the AQWebSocketManager and get the AQI datas
GraphContoller will used to show the Graph view, when user select the particular city
The Graph view will update every 30 sec's as a new view
The Total time taken for this app 12 hours

<img width="559" alt="Screenshot 2021-12-05 at 5 39 01 PM" src="https://user-images.githubusercontent.com/91929460/144745975-a1997fd5-30ec-4242-a98e-9380dc9d0be3.png">
<img width="559" alt="Screenshot 2021-12-05 at 5 40 08 PM" src="https://user-images.githubusercontent.com/91929460/144745983-2b297321-8f5d-442d-838e-b4aea6cc4527.png">
