var map;
var home={lat:0, lng:0};
var radius;
function initMap() {

  var Hyderabad = {lat:17.397367 ,lng: 78.490102};
  console.log(Hyderabad.lat);
  map = new google.maps.Map(document.getElementById('map'), {
  zoom: 10,
  center: Hyderabad,
});
};

var pubnub = new PubNub({
    subscribeKey: "sub-c-4222e1b0-2cf6-11e9-aaa1-ea6b46e20ca7",
    publishKey: "pub-c-5ae30807-4567-40dc-8a93-66d2617b8398",
    ssl: true
})

pubnub.addListener({
    message: function(m) {
        // handle message
        var channelName = m.channel; // The channel for which the message belongs
        var channelGroup = m.subscription; // The channel group or wildcard subscription match (if exists)
        var pubTT = m.timetoken; // Publish timetoken
        var msg = m.message; // The Payload
        var publisher = m.publisher; //The Publisher
		    console.log(msg);
        console.log(typeof msg);
        eval('var obj='+msg);
        console.log(obj);
        var marker1 = new google.maps.Marker({
            map: map,
            position: obj,
            animation: google.maps.Animation.DROP,
            icon: {
                  path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                  scale: 10
                },
        });
        if(home.lat!=0 || home.lng!=0){
        var dist = distcal(home.lat, home.lng, obj.lat, obj.lng);
        console.log(dist);
        if(dist>radius){
          console.log("Geofence Breach Detected!");
          sendNotification();
        }
      else{
        console.log("All cool here!");
      }
    }

    },
});

function myFunction() {
var x,y,z;
x = document.getElementById("myForm").elements[0].value;
y = document.getElementById("myForm").elements[1].value;
z = document.getElementById("mySelect").value;
if(x==0 || y==0){
alert("Please enter lat and long values");
}
else{
  home = {lat: parseFloat(x), lng: parseFloat(y)};
  radius = parseFloat(z);
  console.log(home);
  console.log(radius);
  var marker = new google.maps.Marker({
      map: map,
      position: home,
      animation: google.maps.Animation.DROP,
  });
};
}

function degreesToRadians(degrees) {
  return degrees * Math.PI / 180;
}

function distcal(lat1, lon1, lat2, lon2) {
  var earthRadiusKm = 6371;

  var dLat = degreesToRadians(lat2-lat1);
  var dLon = degreesToRadians(lon2-lon1);

  lat1 = degreesToRadians(lat1);
  lat2 = degreesToRadians(lat2);

  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return(earthRadiusKm * c * 1000);
}

PushBullet.APIKey= "o.VJPIZR26zRitgOeTTXHxU43HEWeiUSM7";

function sendNotification(){
  var devID = "ujCVnYUKicKsjz99WkCibI";
  var res = PushBullet.push("note", devID, null, {title: "GeoFence Breach!", body: "We've just detected a GeoFence Breach! "});
}


console.log("Subscribing..");
    pubnub.subscribe({
        channels: ['geofence']
    });
