import 'package:app_psikolog/model/MentalHealth_model.dart';
import 'package:flutter/material.dart';
// import '../models/mental_health_tip.dart';

class TipDetailPage extends StatelessWidget {
  final MentalHealthTip tip;

  const TipDetailPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fabd4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BA6DF),
        title: Text(tip.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  tip.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tip.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tip.time,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Text(
                tip.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
