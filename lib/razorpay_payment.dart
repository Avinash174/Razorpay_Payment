import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  const RazorpayPayment({super.key});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  Razorpay _razorpay = Razorpay();
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_EvbvmLyM4daKbK',
      'amount': 5000, //in the smallest currency sub-unit.
      'name': 'Avinash Magar',
      'timeout': 60,
      'wallet': {'gpay'},
      'prefill': {'contact': '7058700755', 'email': 'avinashmagar15@gmail.com'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(
      msg: "Payment Successful" + response.paymentId!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(
      msg: 'Paymet Failed' + response.message!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    Fluttertoast.showToast(
      msg: 'External Wallet',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Razorpay_logo.svg/1599px-Razorpay_logo.svg.png',
                width: 300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Welcome To Rezorpay Payment Gateway',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount To Paid',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15.0,
                  ),
                ),
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Amount To Be Paid';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (amtController.text.toString().isNotEmpty) {
                  setState(() {
                    int amount = int.parse(amtController.text.toString());
                    openCheckout(amount);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Make Payment'),
              ),
              style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
