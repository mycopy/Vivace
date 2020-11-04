{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ ™
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   game toolkit

 Copyright © 2020 tinyBigGAMES™ LLC
 All rights reserved.

 website: https://tinybiggames.com
 email  : support@tinybiggames.com

 LICENSE: zlib/libpng

 Vivace Game Toolkit is licensed under an unmodified zlib/libpng license,
 which is an OSI-certified, BSD-like license that allows static linking
 with closed source software:

 This software is provided "as-is", without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software in
     a product, an acknowledgment in the product documentation would be
     appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.

============================================================================== }


unit Vivace.ENet.API;

{$I Vivace.Defines.inc}

interface

uses
  WinApi.WinSock2,
  Vivace.Common;

type
  // Forward declarations
  PENetBuffer = ^ENetBuffer;
  P_ENetCallbacks = ^_ENetCallbacks;
  P_ENetListNode = ^_ENetListNode;
  P_ENetList = ^_ENetList;
  P_ENetProtocolHeader = ^_ENetProtocolHeader;
  P_ENetProtocolCommandHeader = ^_ENetProtocolCommandHeader;
  P_ENetProtocolAcknowledge = ^_ENetProtocolAcknowledge;
  P_ENetProtocolConnect = ^_ENetProtocolConnect;
  P_ENetProtocolVerifyConnect = ^_ENetProtocolVerifyConnect;
  P_ENetProtocolBandwidthLimit = ^_ENetProtocolBandwidthLimit;
  P_ENetProtocolThrottleConfigure = ^_ENetProtocolThrottleConfigure;
  P_ENetProtocolDisconnect = ^_ENetProtocolDisconnect;
  P_ENetProtocolPing = ^_ENetProtocolPing;
  P_ENetProtocolSendReliable = ^_ENetProtocolSendReliable;
  P_ENetProtocolSendUnreliable = ^_ENetProtocolSendUnreliable;
  P_ENetProtocolSendUnsequenced = ^_ENetProtocolSendUnsequenced;
  P_ENetProtocolSendFragment = ^_ENetProtocolSendFragment;
  P_ENetAddress = ^_ENetAddress;
  P_ENetPacket = ^_ENetPacket;
  P_ENetAcknowledgement = ^_ENetAcknowledgement;
  P_ENetOutgoingCommand = ^_ENetOutgoingCommand;
  P_ENetIncomingCommand = ^_ENetIncomingCommand;
  P_ENetChannel = ^_ENetChannel;
  P_ENetPeer = ^_ENetPeer;
  P_ENetCompressor = ^_ENetCompressor;
  P_ENetHost = ^_ENetHost;
  P_ENetEvent = ^_ENetEvent;

  ENetSocket = TSOCKET;

  ENetBuffer = record
    dataLength: NativeUInt;
    data: Pointer;
  end;

  ENetSocketSet = fd_set;
  PENetSocketSet = ^ENetSocketSet;
  enet_uint8 = UInt8;
  Penet_uint8 = ^enet_uint8;
  PPenet_uint8 = ^Penet_uint8;
  enet_uint16 = UInt16;
  enet_uint32 = UInt32;
  Penet_uint32 = ^enet_uint32;
  enet_uint64 = UInt64;
  ENetVersion = enet_uint32;
  PENetPacket = ^ENetPacket;

  _ENetCallbacks = record
    malloc: function(size: NativeUInt): Pointer; cdecl;
    free: procedure(memory: Pointer); cdecl;
    no_memory: procedure(); cdecl;
    packet_create: function(const data: Pointer; dataLength: NativeUInt; flags: enet_uint32): PENetPacket; cdecl;
    packet_destroy: procedure(packet: PENetPacket); cdecl;
  end;

  ENetCallbacks = _ENetCallbacks;
  PENetCallbacks = ^ENetCallbacks;

  _ENetListNode = record
    next: P_ENetListNode;
    previous: P_ENetListNode;
  end;

  ENetListNode = _ENetListNode;
  ENetListIterator = ^_ENetListNode;

  _ENetList = record
    sentinel: ENetListNode;
  end;

  ENetList = _ENetList;
  PENetList = ^ENetList;

  _anonymous_type_1 = (
    ENET_PROTOCOL_MINIMUM_MTU = 576,
    ENET_PROTOCOL_MAXIMUM_MTU = 4096,
    ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS = 32,
    ENET_PROTOCOL_MINIMUM_WINDOW_SIZE = 4096,
    ENET_PROTOCOL_MAXIMUM_WINDOW_SIZE = 65536,
    ENET_PROTOCOL_MINIMUM_CHANNEL_COUNT = 1,
    ENET_PROTOCOL_MAXIMUM_CHANNEL_COUNT = 255,
    ENET_PROTOCOL_MAXIMUM_PEER_ID = 4095,
    ENET_PROTOCOL_MAXIMUM_FRAGMENT_COUNT = 1048576);
  P_anonymous_type_1 = ^_anonymous_type_1;

  _ENetProtocolCommand = (
    ENET_PROTOCOL_COMMAND_NONE = 0,
    ENET_PROTOCOL_COMMAND_ACKNOWLEDGE = 1,
    ENET_PROTOCOL_COMMAND_CONNECT = 2,
    ENET_PROTOCOL_COMMAND_VERIFY_CONNECT = 3,
    ENET_PROTOCOL_COMMAND_DISCONNECT = 4,
    ENET_PROTOCOL_COMMAND_PING = 5,
    ENET_PROTOCOL_COMMAND_SEND_RELIABLE = 6,
    ENET_PROTOCOL_COMMAND_SEND_UNRELIABLE = 7,
    ENET_PROTOCOL_COMMAND_SEND_FRAGMENT = 8,
    ENET_PROTOCOL_COMMAND_SEND_UNSEQUENCED = 9,
    ENET_PROTOCOL_COMMAND_BANDWIDTH_LIMIT = 10,
    ENET_PROTOCOL_COMMAND_THROTTLE_CONFIGURE = 11,
    ENET_PROTOCOL_COMMAND_SEND_UNRELIABLE_FRAGMENT = 12,
    ENET_PROTOCOL_COMMAND_COUNT = 13,
    ENET_PROTOCOL_COMMAND_MASK = 15);
  P_ENetProtocolCommand = ^_ENetProtocolCommand;
  ENetProtocolCommand = _ENetProtocolCommand;

  _ENetProtocolFlag = (
    ENET_PROTOCOL_COMMAND_FLAG_ACKNOWLEDGE = 128,
    ENET_PROTOCOL_COMMAND_FLAG_UNSEQUENCED = 64,
    ENET_PROTOCOL_HEADER_FLAG_COMPRESSED = 16384,
    ENET_PROTOCOL_HEADER_FLAG_SENT_TIME = 32768,
    ENET_PROTOCOL_HEADER_FLAG_MASK = 49152,
    ENET_PROTOCOL_HEADER_SESSION_MASK = 12288,
    ENET_PROTOCOL_HEADER_SESSION_SHIFT = 12);
  P_ENetProtocolFlag = ^_ENetProtocolFlag;
  ENetProtocolFlag = _ENetProtocolFlag;

  _ENetProtocolHeader = record
    peerID: enet_uint16;
    sentTime: enet_uint16;
  end;

  ENetProtocolHeader = _ENetProtocolHeader;

  _ENetProtocolCommandHeader = record
    command: enet_uint8;
    channelID: enet_uint8;
    reliableSequenceNumber: enet_uint16;
  end;

  ENetProtocolCommandHeader = _ENetProtocolCommandHeader;

  _ENetProtocolAcknowledge = record
    header: ENetProtocolCommandHeader;
    receivedReliableSequenceNumber: enet_uint16;
    receivedSentTime: enet_uint16;
  end;

  ENetProtocolAcknowledge = _ENetProtocolAcknowledge;

  _ENetProtocolConnect = record
    header: ENetProtocolCommandHeader;
    outgoingPeerID: enet_uint16;
    incomingSessionID: enet_uint8;
    outgoingSessionID: enet_uint8;
    mtu: enet_uint32;
    windowSize: enet_uint32;
    channelCount: enet_uint32;
    incomingBandwidth: enet_uint32;
    outgoingBandwidth: enet_uint32;
    packetThrottleInterval: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
    connectID: enet_uint32;
    data: enet_uint32;
  end;

  ENetProtocolConnect = _ENetProtocolConnect;

  _ENetProtocolVerifyConnect = record
    header: ENetProtocolCommandHeader;
    outgoingPeerID: enet_uint16;
    incomingSessionID: enet_uint8;
    outgoingSessionID: enet_uint8;
    mtu: enet_uint32;
    windowSize: enet_uint32;
    channelCount: enet_uint32;
    incomingBandwidth: enet_uint32;
    outgoingBandwidth: enet_uint32;
    packetThrottleInterval: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
    connectID: enet_uint32;
  end;

  ENetProtocolVerifyConnect = _ENetProtocolVerifyConnect;

  _ENetProtocolBandwidthLimit = record
    header: ENetProtocolCommandHeader;
    incomingBandwidth: enet_uint32;
    outgoingBandwidth: enet_uint32;
  end;

  ENetProtocolBandwidthLimit = _ENetProtocolBandwidthLimit;

  _ENetProtocolThrottleConfigure = record
    header: ENetProtocolCommandHeader;
    packetThrottleInterval: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
  end;

  ENetProtocolThrottleConfigure = _ENetProtocolThrottleConfigure;

  _ENetProtocolDisconnect = record
    header: ENetProtocolCommandHeader;
    data: enet_uint32;
  end;

  ENetProtocolDisconnect = _ENetProtocolDisconnect;

  _ENetProtocolPing = record
    header: ENetProtocolCommandHeader;
  end;

  ENetProtocolPing = _ENetProtocolPing;

  _ENetProtocolSendReliable = record
    header: ENetProtocolCommandHeader;
    dataLength: enet_uint16;
  end;

  ENetProtocolSendReliable = _ENetProtocolSendReliable;

  _ENetProtocolSendUnreliable = record
    header: ENetProtocolCommandHeader;
    unreliableSequenceNumber: enet_uint16;
    dataLength: enet_uint16;
  end;

  ENetProtocolSendUnreliable = _ENetProtocolSendUnreliable;

  _ENetProtocolSendUnsequenced = record
    header: ENetProtocolCommandHeader;
    unsequencedGroup: enet_uint16;
    dataLength: enet_uint16;
  end;

  ENetProtocolSendUnsequenced = _ENetProtocolSendUnsequenced;

  _ENetProtocolSendFragment = record
    header: ENetProtocolCommandHeader;
    startSequenceNumber: enet_uint16;
    dataLength: enet_uint16;
    fragmentCount: enet_uint32;
    fragmentNumber: enet_uint32;
    totalLength: enet_uint32;
    fragmentOffset: enet_uint32;
  end;

  ENetProtocolSendFragment = _ENetProtocolSendFragment;

  _ENetProtocol = record
    case Integer of
      0: (header: ENetProtocolCommandHeader);
      1: (acknowledge: ENetProtocolAcknowledge);
      2: (connect: ENetProtocolConnect);
      3: (verifyConnect: ENetProtocolVerifyConnect);
      4: (disconnect: ENetProtocolDisconnect);
      5: (ping: ENetProtocolPing);
      6: (sendReliable: ENetProtocolSendReliable);
      7: (sendUnreliable: ENetProtocolSendUnreliable);
      8: (sendUnsequenced: ENetProtocolSendUnsequenced);
      9: (sendFragment: ENetProtocolSendFragment);
      10: (bandwidthLimit: ENetProtocolBandwidthLimit);
      11: (throttleConfigure: ENetProtocolThrottleConfigure);
  end;

  ENetProtocol = _ENetProtocol;
  PENetProtocol = ^ENetProtocol;

  _ENetSocketType = (
    ENET_SOCKET_TYPE_STREAM = 1,
    ENET_SOCKET_TYPE_DATAGRAM = 2);
  P_ENetSocketType = ^_ENetSocketType;
  ENetSocketType = _ENetSocketType;

  _ENetSocketWait = (
    ENET_SOCKET_WAIT_NONE = 0,
    ENET_SOCKET_WAIT_SEND = 1,
    ENET_SOCKET_WAIT_RECEIVE = 2,
    ENET_SOCKET_WAIT_INTERRUPT = 4);
  P_ENetSocketWait = ^_ENetSocketWait;
  ENetSocketWait = _ENetSocketWait;

  _ENetSocketOption = (
    ENET_SOCKOPT_NONBLOCK = 1,
    ENET_SOCKOPT_BROADCAST = 2,
    ENET_SOCKOPT_RCVBUF = 3,
    ENET_SOCKOPT_SNDBUF = 4,
    ENET_SOCKOPT_REUSEADDR = 5,
    ENET_SOCKOPT_RCVTIMEO = 6,
    ENET_SOCKOPT_SNDTIMEO = 7,
    ENET_SOCKOPT_ERROR = 8,
    ENET_SOCKOPT_NODELAY = 9,
    ENET_SOCKOPT_IPV6_V6ONLY = 10);
  P_ENetSocketOption = ^_ENetSocketOption;
  ENetSocketOption = _ENetSocketOption;

  _ENetSocketShutdown = (
    ENET_SOCKET_SHUTDOWN_READ = 0,
    ENET_SOCKET_SHUTDOWN_WRITE = 1,
    ENET_SOCKET_SHUTDOWN_READ_WRITE = 2);
  P_ENetSocketShutdown = ^_ENetSocketShutdown;
  ENetSocketShutdown = _ENetSocketShutdown;

  (**
   * Portable internet address structure.
   *
   * The host must be specified in network byte-order, and the port must be in host
   * byte-order. The constant ENET_HOST_ANY may be used to specify the default
   * server host. The constant ENET_HOST_BROADCAST may be used to specify the
   * broadcast address (255.255.255.255).  This makes sense for enet_host_connect,
   * but not for enet_host_create.  Once a server responds to a broadcast, the
   * address is updated from ENET_HOST_BROADCAST to the server's actual IP address.
   *)
  _ENetAddress = record
    host: cardinal;
    port: enet_uint16;
    sin6_scope_id: enet_uint16;
  end;

  ENetAddress = _ENetAddress;
  PENetAddress = ^ENetAddress;

  (**
   * Packet flag bit constants.
   *
   * The host must be specified in network byte-order, and the port must be in
   * host byte-order. The constant ENET_HOST_ANY may be used to specify the
   * default server host.
   *
   * @sa ENetPacket
   *)
  _ENetPacketFlag = (
    ENET_PACKET_FLAG_RELIABLE = 1,
    (** packet must be received by the target peer and resend attempts should be made until the packet is delivered *)
    ENET_PACKET_FLAG_UNSEQUENCED = 2,
    (** packet will not be sequenced with other packets not supported for reliable packets *)
    ENET_PACKET_FLAG_NO_ALLOCATE = 4,
    (** packet will not allocate data, and user must supply it instead *)
    ENET_PACKET_FLAG_UNRELIABLE_FRAGMENT = 8,
    (** packet will be fragmented using unreliable (instead of reliable) sends if it exceeds the MTU *)
    ENET_PACKET_FLAG_SENT = 256);
  P_ENetPacketFlag = ^_ENetPacketFlag;
  ENetPacketFlag = _ENetPacketFlag;

  ENetPacketFreeCallback = procedure(p1: Pointer); cdecl;

  (**
   * ENet packet structure.
   *
   * An ENet data packet that may be sent to or received from a peer. The shown
   * fields should only be read and never modified. The data field contains the
   * allocated data for the packet. The dataLength fields specifies the length
   * of the allocated data.  The flags field is either 0 (specifying no flags),
   * or a bitwise-or of any combination of the following flags:
   *
   *    ENET_PACKET_FLAG_RELIABLE - packet must be received by the target peer and resend attempts should be made until the packet is delivered
   *    ENET_PACKET_FLAG_UNSEQUENCED - packet will not be sequenced with other packets (not supported for reliable packets)
   *    ENET_PACKET_FLAG_NO_ALLOCATE - packet will not allocate data, and user must supply it instead
   *    ENET_PACKET_FLAG_UNRELIABLE_FRAGMENT - packet will be fragmented using unreliable (instead of reliable) sends if it exceeds the MTU
   *    ENET_PACKET_FLAG_SENT - whether the packet has been sent from all queues it has been entered into
   * @sa ENetPacketFlag
   *)
  //ENetPacket = _ENetPacket;
  _ENetPacket = record
    (** internal use only *)
    referenceCount: NativeUInt;
    (** bitwise-or of ENetPacketFlag constants *)
    flags: enet_uint32;
    (** allocated data for packet *)
    data: Penet_uint8;
    (** length of data *)
    dataLength: NativeUInt;
    (** function to be called when the packet is no longer in use *)
    freeCallback: ENetPacketFreeCallback;
    (** application private data, may be freely modified *)
    userData: Pointer;
  end;

  ENetPacket = _ENetPacket;
 // PENetPacket = ^ENetPacket;

  _ENetAcknowledgement = record
    acknowledgementList: ENetListNode;
    sentTime: enet_uint32;
    command: ENetProtocol;
  end;

  ENetAcknowledgement = _ENetAcknowledgement;
  PENetAcknowledgement = ^ENetAcknowledgement;

  _ENetOutgoingCommand = record
    outgoingCommandList: ENetListNode;
    reliableSequenceNumber: enet_uint16;
    unreliableSequenceNumber: enet_uint16;
    sentTime: enet_uint32;
    roundTripTimeout: enet_uint32;
    roundTripTimeoutLimit: enet_uint32;
    fragmentOffset: enet_uint32;
    fragmentLength: enet_uint16;
    sendAttempts: enet_uint16;
    command: ENetProtocol;
    packet: PENetPacket;
  end;

  ENetOutgoingCommand = _ENetOutgoingCommand;
  PENetOutgoingCommand = ^ENetOutgoingCommand;

  _ENetIncomingCommand = record
    incomingCommandList: ENetListNode;
    reliableSequenceNumber: enet_uint16;
    unreliableSequenceNumber: enet_uint16;
    command: ENetProtocol;
    fragmentCount: enet_uint32;
    fragmentsRemaining: enet_uint32;
    fragments: Penet_uint32;
    packet: PENetPacket;
  end;

  ENetIncomingCommand = _ENetIncomingCommand;
  PENetIncomingCommand = ^ENetIncomingCommand;

  _ENetPeerState = (
    ENET_PEER_STATE_DISCONNECTED = 0,
    ENET_PEER_STATE_CONNECTING = 1,
    ENET_PEER_STATE_ACKNOWLEDGING_CONNECT = 2,
    ENET_PEER_STATE_CONNECTION_PENDING = 3,
    ENET_PEER_STATE_CONNECTION_SUCCEEDED = 4,
    ENET_PEER_STATE_CONNECTED = 5,
    ENET_PEER_STATE_DISCONNECT_LATER = 6,
    ENET_PEER_STATE_DISCONNECTING = 7,
    ENET_PEER_STATE_ACKNOWLEDGING_DISCONNECT = 8,
    ENET_PEER_STATE_ZOMBIE = 9);
  P_ENetPeerState = ^_ENetPeerState;
  ENetPeerState = _ENetPeerState;

  _anonymous_type_2 = (
    ENET_HOST_RECEIVE_BUFFER_SIZE = 262144,
    ENET_HOST_SEND_BUFFER_SIZE = 262144,
    ENET_HOST_BANDWIDTH_THROTTLE_INTERVAL = 1000,
    ENET_HOST_DEFAULT_MTU = 1400,
    ENET_HOST_DEFAULT_MAXIMUM_PACKET_SIZE = 33554432,
    ENET_HOST_DEFAULT_MAXIMUM_WAITING_DATA = 33554432,
    ENET_PEER_DEFAULT_ROUND_TRIP_TIME = 500,
    ENET_PEER_DEFAULT_PACKET_THROTTLE = 32,
    ENET_PEER_PACKET_THROTTLE_SCALE = 32,
    ENET_PEER_PACKET_THROTTLE_COUNTER = 7,
    ENET_PEER_PACKET_THROTTLE_ACCELERATION = 2,
    ENET_PEER_PACKET_THROTTLE_DECELERATION = 2,
    ENET_PEER_PACKET_THROTTLE_INTERVAL = 5000,
    ENET_PEER_PACKET_LOSS_SCALE = 65536,
    ENET_PEER_PACKET_LOSS_INTERVAL = 10000,
    ENET_PEER_WINDOW_SIZE_SCALE = 65536,
    ENET_PEER_TIMEOUT_LIMIT = 32,
    ENET_PEER_TIMEOUT_MINIMUM = 5000,
    ENET_PEER_TIMEOUT_MAXIMUM = 30000,
    ENET_PEER_PING_INTERVAL_ = 500,
    ENET_PEER_UNSEQUENCED_WINDOWS = 64,
    ENET_PEER_UNSEQUENCED_WINDOW_SIZE = 1024,
    ENET_PEER_FREE_UNSEQUENCED_WINDOWS = 32,
    ENET_PEER_RELIABLE_WINDOWS = 16,
    ENET_PEER_RELIABLE_WINDOW_SIZE = 4096,
    ENET_PEER_FREE_RELIABLE_WINDOWS = 8);
  P_anonymous_type_2 = ^_anonymous_type_2;

  _ENetChannel = record
    outgoingReliableSequenceNumber: enet_uint16;
    outgoingUnreliableSequenceNumber: enet_uint16;
    usedReliableWindows: enet_uint16;
    reliableWindows: array [0..15] of enet_uint16;
    incomingReliableSequenceNumber: enet_uint16;
    incomingUnreliableSequenceNumber: enet_uint16;
    incomingReliableCommands: ENetList;
    incomingUnreliableCommands: ENetList;
  end;

  ENetChannel = _ENetChannel;
  PENetChannel = ^ENetChannel;

  (**
   * An ENet peer which data packets may be sent or received from.
   *
   * No fields should be modified unless otherwise specified.
   *)
  _ENetPeer = record
    dispatchList: ENetListNode;
    host: P_ENetHost;
    outgoingPeerID: enet_uint16;
    incomingPeerID: enet_uint16;
    connectID: enet_uint32;
    outgoingSessionID: enet_uint8;
    incomingSessionID: enet_uint8;
    (** Internet address of the peer *)
    address: ENetAddress;
    (** Application private data, may be freely modified *)
    data: Pointer;
    state: ENetPeerState;
    channels: PENetChannel;
    (** Number of channels allocated for communication with peer *)
    channelCount: NativeUInt;
    (** Downstream bandwidth of the client in bytes/second *)
    incomingBandwidth: enet_uint32;
    (** Upstream bandwidth of the client in bytes/second *)
    outgoingBandwidth: enet_uint32;
    incomingBandwidthThrottleEpoch: enet_uint32;
    outgoingBandwidthThrottleEpoch: enet_uint32;
    incomingDataTotal: enet_uint32;
    totalDataReceived: enet_uint64;
    outgoingDataTotal: enet_uint32;
    totalDataSent: enet_uint64;
    lastSendTime: enet_uint32;
    lastReceiveTime: enet_uint32;
    nextTimeout: enet_uint32;
    earliestTimeout: enet_uint32;
    packetLossEpoch: enet_uint32;
    packetsSent: enet_uint32;
    (** total number of packets sent during a session *)
    totalPacketsSent: enet_uint64;
    packetsLost: enet_uint32;
    (** total number of packets lost during a session *)
    totalPacketsLost: enet_uint32;
    (** mean packet loss of reliable packets as a ratio with respect to the constant ENET_PEER_PACKET_LOSS_SCALE *)
    packetLoss: enet_uint32;
    packetLossVariance: enet_uint32;
    packetThrottle: enet_uint32;
    packetThrottleLimit: enet_uint32;
    packetThrottleCounter: enet_uint32;
    packetThrottleEpoch: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
    packetThrottleInterval: enet_uint32;
    pingInterval: enet_uint32;
    timeoutLimit: enet_uint32;
    timeoutMinimum: enet_uint32;
    timeoutMaximum: enet_uint32;
    lastRoundTripTime: enet_uint32;
    lowestRoundTripTime: enet_uint32;
    lastRoundTripTimeVariance: enet_uint32;
    highestRoundTripTimeVariance: enet_uint32;
    (** mean round trip time (RTT), in milliseconds, between sending a reliable packet and receiving its acknowledgement *)
    roundTripTime: enet_uint32;
    roundTripTimeVariance: enet_uint32;
    mtu: enet_uint32;
    windowSize: enet_uint32;
    reliableDataInTransit: enet_uint32;
    outgoingReliableSequenceNumber: enet_uint16;
    acknowledgements: ENetList;
    sentReliableCommands: ENetList;
    sentUnreliableCommands: ENetList;
    outgoingReliableCommands: ENetList;
    outgoingUnreliableCommands: ENetList;
    dispatchedCommands: ENetList;
    needsDispatch: Integer;
    incomingUnsequencedGroup: enet_uint16;
    outgoingUnsequencedGroup: enet_uint16;
    unsequencedWindow: array [0..31] of enet_uint32;
    eventData: enet_uint32;
    totalWaitingData: NativeUInt;
  end;

  ENetPeer = _ENetPeer;
  PENetPeer = ^ENetPeer;

  (** An ENet packet compressor for compressing UDP packets before socket sends or receives. *)
  _ENetCompressor = record
    (** Context data for the compressor. Must be non-NULL. *)
    context: Pointer;
    (** Compresses from inBuffers[0:inBufferCount-1], containing inLimit bytes, to outData, outputting at most outLimit bytes. Should return 0 on failure. *)
    compress: function(context: Pointer; const inBuffers: PENetBuffer; inBufferCount: NativeUInt; inLimit: NativeUInt; outData: Penet_uint8; outLimit: NativeUInt): NativeUInt; cdecl;
    (** Decompresses from inData, containing inLimit bytes, to outData, outputting at most outLimit bytes. Should return 0 on failure. *)
    decompress: function(context: Pointer; const inData: Penet_uint8; inLimit: NativeUInt; outData: Penet_uint8; outLimit: NativeUInt): NativeUInt; cdecl;
    (** Destroys the context when compression is disabled or the host is destroyed. May be NULL. *)
    destroy: procedure(context: Pointer); cdecl;
  end;

  ENetCompressor = _ENetCompressor;
  PENetCompressor = ^ENetCompressor;

  (** Callback that computes the checksum of the data held in buffers[0:bufferCount-1] *)
  ENetChecksumCallback = function(const buffers: PENetBuffer; bufferCount: NativeUInt): enet_uint32; cdecl;

  (** Callback for intercepting received raw UDP packets. Should return 1 to intercept, 0 to ignore, or -1 to propagate an error. *)
  ENetInterceptCallback = function(host: P_ENetHost; event: Pointer): Integer; cdecl;

  (** An ENet host for communicating with peers.
   *
   * No fields should be modified unless otherwise stated.
   *
   *  @sa enet_host_create()
   *  @sa enet_host_destroy()
   *  @sa enet_host_connect()
   *  @sa enet_host_service()
   *  @sa enet_host_flush()
   *  @sa enet_host_broadcast()
   *  @sa enet_host_compress()
   *  @sa enet_host_channel_limit()
   *  @sa enet_host_bandwidth_limit()
   *  @sa enet_host_bandwidth_throttle()
   *)
  _ENetHost = record
    socket: ENetSocket;
    (** Internet address of the host *)
    address: ENetAddress;
    (** downstream bandwidth of the host *)
    incomingBandwidth: enet_uint32;
    (** upstream bandwidth of the host *)
    outgoingBandwidth: enet_uint32;
    bandwidthThrottleEpoch: enet_uint32;
    mtu: enet_uint32;
    randomSeed: enet_uint32;
    recalculateBandwidthLimits: Integer;
    (** array of peers allocated for this host *)
    peers: PENetPeer;
    (** number of peers allocated for this host *)
    peerCount: NativeUInt;
    (** maximum number of channels allowed for connected peers *)
    channelLimit: NativeUInt;
    serviceTime: enet_uint32;
    dispatchQueue: ENetList;
    continueSending: Integer;
    packetSize: NativeUInt;
    headerFlags: enet_uint16;
    commands: array [0..31] of ENetProtocol;
    commandCount: NativeUInt;
    buffers: array [0..64] of ENetBuffer;
    bufferCount: NativeUInt;
    (** callback the user can set to enable packet checksums for this host *)
    checksum: ENetChecksumCallback;
    compressor: ENetCompressor;
    packetData: array [0..1] of array [0..4095] of enet_uint8;
    receivedAddress: ENetAddress;
    receivedData: Penet_uint8;
    receivedDataLength: NativeUInt;
    (** total data sent, user should reset to 0 as needed to prevent overflow *)
    totalSentData: enet_uint32;
    (** total UDP packets sent, user should reset to 0 as needed to prevent overflow *)
    totalSentPackets: enet_uint32;
    (** total data received, user should reset to 0 as needed to prevent overflow *)
    totalReceivedData: enet_uint32;
    (** total UDP packets received, user should reset to 0 as needed to prevent overflow *)
    totalReceivedPackets: enet_uint32;
    (** callback the user can set to intercept received raw UDP packets *)
    intercept: ENetInterceptCallback;
    connectedPeers: NativeUInt;
    bandwidthLimitedPeers: NativeUInt;
    (** optional number of allowed peers from duplicate IPs, defaults to ENET_PROTOCOL_MAXIMUM_PEER_ID *)
    duplicatePeers: NativeUInt;
    (** the maximum allowable packet size that may be sent or received on a peer *)
    maximumPacketSize: NativeUInt;
    (** the maximum aggregate amount of buffer space a peer may use waiting for packets to be delivered *)
    maximumWaitingData: NativeUInt;
  end;

  ENetHost = _ENetHost;
  PENetHost = ^ENetHost;

  (**
   * An ENet event type, as specified in @ref ENetEvent.
   *)
  _ENetEventType = (
    (** no event occurred within the specified time limit *)
    ENET_EVENT_TYPE_NONE = 0,
    (** a connection request initiated by enet_host_connect has completed.
     * The peer field contains the peer which successfully connected.
     *)
    ENET_EVENT_TYPE_CONNECT = 1,
    (** a peer has disconnected.  This event is generated on a successful
     * completion of a disconnect initiated by enet_peer_disconnect, if
     * a peer has timed out.  The peer field contains the peer
     * which disconnected. The data field contains user supplied data
     * describing the disconnection, or 0, if none is available.
     *)
    ENET_EVENT_TYPE_DISCONNECT = 2,
    (** a packet has been received from a peer.  The peer field specifies the
     * peer which sent the packet.  The channelID field specifies the channel
     * number upon which the packet was received.  The packet field contains
     * the packet that was received; this packet must be destroyed with
     * enet_packet_destroy after use.
     *)
    ENET_EVENT_TYPE_RECEIVE = 3,
    (** a peer is disconnected because the host didn't receive the acknowledgment
     * packet within certain maximum time out. The reason could be because of bad
     * network connection or  host crashed.
     *)
    ENET_EVENT_TYPE_DISCONNECT_TIMEOUT = 4);
  P_ENetEventType = ^_ENetEventType;
  ENetEventType = _ENetEventType;

  (**
   * An ENet event as returned by enet_host_service().
   *
   * @sa enet_host_service
   *)
  _ENetEvent = record
    (** type of the event *)
    &type: ENetEventType;
    (** peer that generated a connect, disconnect or receive event *)
    peer: PENetPeer;
    (** channel on the peer that generated the event, if appropriate *)
    channelID: enet_uint8;
    (** data associated with the event, if appropriate *)
    data: enet_uint32;
    (** packet associated with the event, if appropriate *)
    packet: PENetPacket;
  end;

  ENetEvent = _ENetEvent;
  PENetEvent = ^ENetEvent;

const
  ENET_VERSION_MAJOR = 2;
  ENET_VERSION_MINOR = 2;
  ENET_VERSION_PATCH = 0;
  ENET_TIME_OVERFLOW = 86400000;
  CLOCK_MONOTONIC = 0;
  ENET_SOCKET_NULL = INVALID_SOCKET;
  ENET_BUFFER_MAXIMUM = (1+2*Ord(ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS));
  ENET_IPV6 = 1;
  ENET_HOST_BROADCAST_ = $FFFFFFFF;
  ENET_PORT_ANY = 0;

function enet_malloc(p1: NativeUInt): Pointer; cdecl;
  external cDllName name _PU + 'enet_malloc';

procedure enet_free(p1: Pointer); cdecl;
  external cDllName name _PU + 'enet_free';

function enet_packet_create(const p1: Pointer; p2: NativeUInt; p3: enet_uint32): PENetPacket; cdecl;
  external cDllName name _PU + 'enet_packet_create';

procedure enet_packet_destroy(p1: PENetPacket); cdecl;
  external cDllName name _PU + 'enet_packet_destroy';

function enet_list_insert(p1: ENetListIterator; p2: Pointer): ENetListIterator; cdecl;
  external cDllName name _PU + 'enet_list_insert';

function enet_list_move(p1: ENetListIterator; p2: Pointer; p3: Pointer): ENetListIterator; cdecl;
  external cDllName name _PU + 'enet_list_move';

function enet_list_remove(p1: ENetListIterator): Pointer; cdecl;
  external cDllName name _PU + 'enet_list_remove';

procedure enet_list_clear(p1: PENetList); cdecl;
  external cDllName name _PU + 'enet_list_clear';

function enet_list_size(p1: PENetList): NativeUInt; cdecl;
  external cDllName name _PU + 'enet_list_size';

(**
 * Initializes ENet globally.  Must be called prior to using any functions in ENet.
 * @returns 0 on success, < 0 on failure
 *)
function enet_initialize(): Integer; cdecl;
  external cDllName name _PU + 'enet_initialize';

(**
 * Initializes ENet globally and supplies user-overridden callbacks. Must be called prior to using any functions in ENet. Do not use enet_initialize() if you use this variant. Make sure the ENetCallbacks structure is zeroed out so that any additional callbacks added in future versions will be properly ignored.
 *
 * @param version the constant ENET_VERSION should be supplied so ENet knows which version of ENetCallbacks struct to use
 * @param inits user-overridden callbacks where any NULL callbacks will use ENet's defaults
 * @returns 0 on success, < 0 on failure
 *)
function enet_initialize_with_callbacks(version: ENetVersion; const inits: PENetCallbacks): Integer; cdecl;
  external cDllName name _PU + 'enet_initialize_with_callbacks';

(**
 * Shuts down ENet globally.  Should be called when a program that has initialized ENet exits.
 *)
procedure enet_deinitialize(); cdecl;
  external cDllName name _PU + 'enet_deinitialize';

(**
 * Gives the linked version of the ENet library.
 * @returns the version number
 *)
function enet_linked_version(): ENetVersion; cdecl;
  external cDllName name _PU + 'enet_linked_version';

(** Returns the monotonic time in milliseconds. Its initial value is unspecified unless otherwise set. *)
function enet_time_get(): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_time_get';

(** ENet socket functions *)
function enet_socket_create(p1: ENetSocketType): ENetSocket; cdecl;
  external cDllName name _PU + 'enet_socket_create';

function enet_socket_bind(p1: ENetSocket; const p2: PENetAddress): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_bind';

function enet_socket_get_address(p1: ENetSocket; p2: PENetAddress): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_get_address';

function enet_socket_listen(p1: ENetSocket; p2: Integer): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_listen';

function enet_socket_accept(p1: ENetSocket; p2: PENetAddress): ENetSocket; cdecl;
  external cDllName name _PU + 'enet_socket_accept';

function enet_socket_connect(p1: ENetSocket; const p2: PENetAddress): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_connect';

function enet_socket_send(p1: ENetSocket; const p2: PENetAddress; const p3: PENetBuffer; p4: NativeUInt): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_send';

function enet_socket_receive(p1: ENetSocket; p2: PENetAddress; p3: PENetBuffer; p4: NativeUInt): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_receive';

function enet_socket_wait(p1: ENetSocket; p2: Penet_uint32; p3: enet_uint64): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_wait';

function enet_socket_set_option(p1: ENetSocket; p2: ENetSocketOption; p3: Integer): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_set_option';

function enet_socket_get_option(p1: ENetSocket; p2: ENetSocketOption; p3: PInteger): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_get_option';

function enet_socket_shutdown(p1: ENetSocket; p2: ENetSocketShutdown): Integer; cdecl;
  external cDllName name _PU + 'enet_socket_shutdown';

procedure enet_socket_destroy(p1: ENetSocket); cdecl;
  external cDllName name _PU + 'enet_socket_destroy';

function enet_socketset_select(p1: ENetSocket; p2: PENetSocketSet; p3: PENetSocketSet; p4: enet_uint32): Integer; cdecl;
  external cDllName name _PU + 'enet_socketset_select';

(** Attempts to parse the printable form of the IP address in the parameter hostName
        and sets the host field in the address parameter if successful.
        @param address destination to store the parsed IP address
        @param hostName IP address to parse
        @retval 0 on success
        @retval < 0 on failure
        @returns the address of the given hostName in address on success
 *)
function enet_address_set_host_ip(address: PENetAddress; const hostName: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'enet_address_set_host_ip';

(** Attempts to resolve the host named by the parameter hostName and sets
        the host field in the address parameter if successful.
        @param address destination to store resolved address
        @param hostName host name to lookup
        @retval 0 on success
        @retval < 0 on failure
        @returns the address of the given hostName in address on success
 *)
function enet_address_set_host(address: PENetAddress; const hostName: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'enet_address_set_host';

(** Gives the printable form of the IP address specified in the address parameter.
        @param address    address printed
        @param hostName   destination for name, must not be NULL
        @param nameLength maximum length of hostName.
        @returns the null-terminated name of the host in hostName on success
        @retval 0 on success
        @retval < 0 on failure
 *)
function enet_address_get_host_ip(const address: PENetAddress; hostName: PUTF8Char; nameLength: NativeUInt): Integer; cdecl;
  external cDllName name _PU + 'enet_address_get_host_ip';

(** Attempts to do a reverse lookup of the host field in the address parameter.
        @param address    address used for reverse lookup
        @param hostName   destination for name, must not be NULL
        @param nameLength maximum length of hostName.
        @returns the null-terminated name of the host in hostName on success
        @retval 0 on success
        @retval < 0 on failure
 *)
function enet_address_get_host(const address: PENetAddress; hostName: PUTF8Char; nameLength: NativeUInt): Integer; cdecl;
  external cDllName name _PU + 'enet_address_get_host';

function enet_host_get_peers_count(p1: PENetHost): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_peers_count';

function enet_host_get_packets_sent(p1: PENetHost): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_packets_sent';

function enet_host_get_packets_received(p1: PENetHost): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_packets_received';

function enet_host_get_bytes_sent(p1: PENetHost): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_bytes_sent';

function enet_host_get_bytes_received(p1: PENetHost): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_bytes_received';

function enet_host_get_received_data(p1: PENetHost; data: PPenet_uint8): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_received_data';

function enet_host_get_mtu(p1: PENetHost): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_host_get_mtu';

function enet_peer_get_id(p1: PENetPeer): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_peer_get_id';

function enet_peer_get_ip(p1: PENetPeer; ip: PUTF8Char; ipLength: NativeUInt): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_peer_get_ip';

function enet_peer_get_port(p1: PENetPeer): enet_uint16; cdecl;
  external cDllName name _PU + 'enet_peer_get_port';

function enet_peer_get_rtt(p1: PENetPeer): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_peer_get_rtt';

function enet_peer_get_packets_sent(p1: PENetPeer): enet_uint64; cdecl;
  external cDllName name _PU + 'enet_peer_get_packets_sent';

function enet_peer_get_packets_lost(p1: PENetPeer): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_peer_get_packets_lost';

function enet_peer_get_bytes_sent(p1: PENetPeer): enet_uint64; cdecl;
  external cDllName name _PU + 'enet_peer_get_bytes_sent';

function enet_peer_get_bytes_received(p1: PENetPeer): enet_uint64; cdecl;
  external cDllName name _PU + 'enet_peer_get_bytes_received';

function enet_peer_get_state(p1: PENetPeer): ENetPeerState; cdecl;
  external cDllName name _PU + 'enet_peer_get_state';

function enet_peer_get_data(p1: PENetPeer): Pointer; cdecl;
  external cDllName name _PU + 'enet_peer_get_data';

procedure enet_peer_set_data(p1: PENetPeer; const p2: Pointer); cdecl;
  external cDllName name _PU + 'enet_peer_set_data';

function enet_packet_get_data(p1: PENetPacket): Pointer; cdecl;
  external cDllName name _PU + 'enet_packet_get_data';

function enet_packet_get_length(p1: PENetPacket): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_packet_get_length';

procedure enet_packet_set_free_callback(p1: PENetPacket; p2: Pointer); cdecl;
  external cDllName name _PU + 'enet_packet_set_free_callback';

function enet_packet_create_offset(const p1: Pointer; p2: NativeUInt; p3: NativeUInt; p4: enet_uint32): PENetPacket; cdecl;
  external cDllName name _PU + 'enet_packet_create_offset';

function enet_crc32(const p1: PENetBuffer; p2: NativeUInt): enet_uint32; cdecl;
  external cDllName name _PU + 'enet_crc32';

function enet_host_create(const p1: PENetAddress; p2: NativeUInt; p3: NativeUInt; p4: enet_uint32; p5: enet_uint32): PENetHost; cdecl;
  external cDllName name _PU + 'enet_host_create';

procedure enet_host_destroy(p1: PENetHost); cdecl;
  external cDllName name _PU + 'enet_host_destroy';

function enet_host_connect(p1: PENetHost; const p2: PENetAddress; p3: NativeUInt; p4: enet_uint32): PENetPeer; cdecl;
  external cDllName name _PU + 'enet_host_connect';

function enet_host_check_events(p1: PENetHost; p2: PENetEvent): Integer; cdecl;
  external cDllName name _PU + 'enet_host_check_events';

function enet_host_service(p1: PENetHost; p2: PENetEvent; p3: enet_uint32): Integer; cdecl;
  external cDllName name _PU + 'enet_host_service';

function enet_host_send_raw(p1: PENetHost; const p2: PENetAddress; p3: Penet_uint8; p4: NativeUInt): Integer; cdecl;
  external cDllName name _PU + 'enet_host_send_raw';

function enet_host_send_raw_ex(host: PENetHost; const address: PENetAddress; data: Penet_uint8; skipBytes: NativeUInt; bytesToSend: NativeUInt): Integer; cdecl;
  external cDllName name _PU + 'enet_host_send_raw_ex';

procedure enet_host_set_intercept(p1: PENetHost; const p2: ENetInterceptCallback); cdecl;
  external cDllName name _PU + 'enet_host_set_intercept';

procedure enet_host_flush(p1: PENetHost); cdecl;
  external cDllName name _PU + 'enet_host_flush';

procedure enet_host_broadcast(p1: PENetHost; p2: enet_uint8; p3: PENetPacket); cdecl;
  external cDllName name _PU + 'enet_host_broadcast';

procedure enet_host_compress(p1: PENetHost; const p2: PENetCompressor); cdecl;
  external cDllName name _PU + 'enet_host_compress';

procedure enet_host_channel_limit(p1: PENetHost; p2: NativeUInt); cdecl;
  external cDllName name _PU + 'enet_host_channel_limit';

procedure enet_host_bandwidth_limit(p1: PENetHost; p2: enet_uint32; p3: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_host_bandwidth_limit';

procedure enet_host_bandwidth_throttle(p1: PENetHost); cdecl;
  external cDllName name _PU + 'enet_host_bandwidth_throttle';

function enet_host_random_seed(): enet_uint64; cdecl;
  external cDllName name _PU + 'enet_host_random_seed';

function enet_peer_send(p1: PENetPeer; p2: enet_uint8; p3: PENetPacket): Integer; cdecl;
  external cDllName name _PU + 'enet_peer_send';

function enet_peer_receive(p1: PENetPeer; channelID: Penet_uint8): PENetPacket; cdecl;
  external cDllName name _PU + 'enet_peer_receive';

procedure enet_peer_ping(p1: PENetPeer); cdecl;
  external cDllName name _PU + 'enet_peer_ping';

procedure enet_peer_ping_interval(p1: PENetPeer; p2: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_peer_ping_interval';

procedure enet_peer_timeout(p1: PENetPeer; p2: enet_uint32; p3: enet_uint32; p4: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_peer_timeout';

procedure enet_peer_reset(p1: PENetPeer); cdecl;
  external cDllName name _PU + 'enet_peer_reset';

procedure enet_peer_disconnect(p1: PENetPeer; p2: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_peer_disconnect';

procedure enet_peer_disconnect_now(p1: PENetPeer; p2: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_peer_disconnect_now';

procedure enet_peer_disconnect_later(p1: PENetPeer; p2: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_peer_disconnect_later';

procedure enet_peer_throttle_configure(p1: PENetPeer; p2: enet_uint32; p3: enet_uint32; p4: enet_uint32); cdecl;
  external cDllName name _PU + 'enet_peer_throttle_configure';

function enet_peer_throttle(p1: PENetPeer; p2: enet_uint32): Integer; cdecl;
  external cDllName name _PU + 'enet_peer_throttle';

procedure enet_peer_reset_queues(p1: PENetPeer); cdecl;
  external cDllName name _PU + 'enet_peer_reset_queues';

procedure enet_peer_setup_outgoing_command(p1: PENetPeer; p2: PENetOutgoingCommand); cdecl;
  external cDllName name _PU + 'enet_peer_setup_outgoing_command';

function enet_peer_queue_outgoing_command(p1: PENetPeer; const p2: PENetProtocol; p3: PENetPacket; p4: enet_uint32; p5: enet_uint16): PENetOutgoingCommand; cdecl;
  external cDllName name _PU + 'enet_peer_queue_outgoing_command';

function enet_peer_queue_incoming_command(p1: PENetPeer; const p2: PENetProtocol; const p3: Pointer; p4: NativeUInt; p5: enet_uint32; p6: enet_uint32): PENetIncomingCommand; cdecl;
  external cDllName name _PU + 'enet_peer_queue_incoming_command';

function enet_peer_queue_acknowledgement(p1: PENetPeer; const p2: PENetProtocol; p3: enet_uint16): PENetAcknowledgement; cdecl;
  external cDllName name _PU + 'enet_peer_queue_acknowledgement';

procedure enet_peer_dispatch_incoming_unreliable_commands(p1: PENetPeer; p2: PENetChannel); cdecl;
  external cDllName name _PU + 'enet_peer_dispatch_incoming_unreliable_commands';

procedure enet_peer_dispatch_incoming_reliable_commands(p1: PENetPeer; p2: PENetChannel); cdecl;
  external cDllName name _PU + 'enet_peer_dispatch_incoming_reliable_commands';

procedure enet_peer_on_connect(p1: PENetPeer); cdecl;
  external cDllName name _PU + 'enet_peer_on_connect';

procedure enet_peer_on_disconnect(p1: PENetPeer); cdecl;
  external cDllName name _PU + 'enet_peer_on_disconnect';

function enet_protocol_command_size(p1: enet_uint8): NativeUInt; cdecl;
  external cDllName name _PU + 'enet_protocol_command_size';

implementation

end.