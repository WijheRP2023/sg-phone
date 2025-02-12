let localStream;
let peer;

navigator.mediaDevices.getUserMedia({ video: true, audio: true })
    .then(stream => {
        document.getElementById("localVideo").srcObject = stream;
        localStream = stream;
    });

function startVideo(peerId) {
    peer = new SimplePeer({ initiator: true, trickle: false, stream: localStream });

    peer.on("signal", data => {
        fetchNUI("sendVideoSignal", { target: peerId, signal: data });
    });

    peer.on("stream", stream => {
        document.getElementById("remoteVideo").srcObject = stream;
    });
}

function acceptVideoCall(peerId) {
    peer = new SimplePeer({ initiator: false, trickle: false, stream: localStream });

    peer.on("signal", data => {
        fetchNUI("sendVideoSignal", { target: peerId, signal: data });
    });

    peer.on("stream", stream => {
        document.getElementById("remoteVideo").srcObject = stream;
    });
}

function endVideoCall() {
    fetchNUI("endVideoCall");
    if (peer) peer.destroy();
}
