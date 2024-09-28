class PaymentModel {
  Strip? strip;
  Wallet? wallet;
  Wallet? cash;
  Paypal? paypal;
  Razorpay? razorpay;
  PayStack? payStack;
  MercadoPago? mercadoPago;
  PayFast? payFast;
  FlutterWave? flutterWave;

  PaymentModel({this.strip, this.wallet, this.cash, this.paypal, this.razorpay, this.payStack, this.mercadoPago});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    strip = json['strip'] != null ? Strip.fromJson(json['strip']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    cash = json['cash'] != null ? Wallet.fromJson(json['cash']) : null;
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
    razorpay = json['razorpay'] != null ? Razorpay.fromJson(json['razorpay']) : null;
    payStack = json['payStack'] != null ? PayStack.fromJson(json['payStack']) : null;
    mercadoPago = json['mercadoPago'] != null ? MercadoPago.fromJson(json['mercadoPago']) : null;
    payFast = json['payFast'] != null ? PayFast.fromJson(json['payFast']) : null;
    flutterWave = json['flutterWave'] != null ? FlutterWave.fromJson(json['flutterWave']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (strip != null) {
      data['strip'] = strip!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (cash != null) {
      data['cash'] = cash!.toJson();
    }
    if (paypal != null) {
      data['paypal'] = paypal!.toJson();
    }
    if (razorpay != null) {
      data['razorpay'] = razorpay!.toJson();
    }
    if (payStack != null) {
      data['payStack'] = payStack!.toJson();
    }
    if (mercadoPago != null) {
      data['mercadoPago'] = mercadoPago!.toJson();
    }
    if (payFast != null) {
      data['payFast'] = payFast!.toJson();
    }
    if (flutterWave != null) {
      data['flutterWave'] = flutterWave!.toJson();
    }
    return data;
  }
}

class Razorpay {
  bool? isActive;
  String? name;
  String? razorpayKey;
  String? razorpaySecret;
  bool? isSandbox;

  Razorpay({this.name, this.isActive, this.isSandbox, this.razorpayKey, this.razorpaySecret,});

  Razorpay.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    name = json['name'];
    razorpayKey = json['razorpayKey'];
    razorpaySecret = json['razorpaySecret'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['isActive'] = isActive;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['razorpayKey'] = razorpayKey;
    data['razorpaySecret'] = razorpaySecret;
    return data;
  }
}

class Strip {
  String? clientPublishableKey;
  String? stripeSecret;
  bool? isActive;
  String? name;
  bool? isSandbox;

  Strip({this.clientPublishableKey, this.stripeSecret, this.isActive, this.name, this.isSandbox,});

  Strip.fromJson(Map<String, dynamic> json) {
    clientPublishableKey = json['clientpublishableKey'];
    stripeSecret = json['stripeSecret'];
    isActive = json['isActive'];
    name = json['name'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientpublishableKey'] = clientPublishableKey;
    data['stripeSecret'] = stripeSecret;
    data['isActive'] = isActive;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class PayStack {
  String? payStackSecret;
  bool? isActive;
  String? name;

  @override
  String toString() {
    return 'PayStack{payStackSecret: $payStackSecret, isActive: $isActive, name: $name,}';
  }

  PayStack({ this.payStackSecret, this.isActive, this.name,});

  PayStack.fromJson(Map<String, dynamic> json) {
    payStackSecret = json['payStackSecret'];
    isActive = json['isActive'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payStackSecret'] = payStackSecret;
    data['isActive'] = isActive;
    data['name'] = name;
    return data;
  }
}

class MercadoPago {
  bool? isActive;
  String? name;
  String? mercadoPagoAccessToken;

  MercadoPago({this.name, this.isActive, this.mercadoPagoAccessToken,});

  @override
  String toString() {
    return 'MercadoPago{isActive: $isActive, name: $name, mercadoPagoAccessToken: $mercadoPagoAccessToken,}';
  }

  MercadoPago.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    name = json['name'];
    mercadoPagoAccessToken = json['mercadoPagoAccessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['isActive'] = isActive;
    data['name'] = name;
    data['mercadoPagoAccessToken'] = mercadoPagoAccessToken;
    return data;
  }
}

class PayFast {
  String? merchantId;
  bool? isActive;
  String? name;
  String? returnUrl;
  String? notifyUrl;
  bool? isSandbox;
  String? cancelUrl;
  String? merchantKey;

  PayFast({this.merchantId, this.isActive, this.name, this.returnUrl, this.notifyUrl, this.isSandbox, this.cancelUrl, this.merchantKey});

  PayFast.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    isActive = json['isActive'];
    name = json['name'];
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    isSandbox = json['isSandbox'];
    cancelUrl = json['cancel_url'];
    merchantKey = json['merchantKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['isActive'] = isActive;
    data['name'] = name;
    data['return_url'] = returnUrl;
    data['notify_url'] = notifyUrl;
    data['isSandbox'] = isSandbox;
    data['cancel_url'] = cancelUrl;
    data['merchantKey'] = merchantKey;
    return data;
  }
}

class FlutterWave {
  bool? isActive;
  String? name;
  String? publicKey;
  bool? isSandBox;

  FlutterWave({this.name, this.isActive, this.publicKey, this.isSandBox});

  @override
  String toString() {
    return 'FlutterWave{isActive: $isActive, name: $name, publicKey: $publicKey, isSandBox: $isSandBox}';
  }

  FlutterWave.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    name = json['name'];
    publicKey = json['publicKey'];
    isSandBox = json['isSandBox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['isActive'] = isActive;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['isSandBox'] = isSandBox;
    return data;
  }
}

class Wallet {
  bool? isActive;
  String? name;

  Wallet({this.isActive, this.name,});

  @override
  String toString() {
    return 'Wallet{isActive: $isActive, name: $name,}';
  }

  Wallet.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['name'] = name;
    return data;
  }
}

class Paypal {
  bool? isActive;
  String? name;
  String? paypalSecret;
  String? paypalClient;
  bool? isSandbox;

  Paypal({this.name, this.isActive, this.paypalSecret, this.isSandbox, this.paypalClient,});

  @override
  String toString() {
    return 'Paypal{isActive: $isActive, name: $name, paypalSecret: $paypalSecret, paypalClient: $paypalClient, isSandbox: $isSandbox}';
  }

  Paypal.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    name = json['name'];
    paypalSecret = json['paypalSecret'];
    paypalClient = json['paypalClient'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['isActive'] = isActive;
    data['name'] = name;
    data['paypalSecret'] = paypalSecret;
    data['isSandbox'] = isSandbox;
    data['paypalClient'] = paypalClient;
    return data;
  }
}
