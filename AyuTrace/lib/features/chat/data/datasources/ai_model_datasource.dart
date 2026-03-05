/// Abstract interface for AI model data source.
/// Implement this interface to plug in your local AI model.
///
/// The mock implementation below returns pre-written responses
/// for demonstration purposes. When you're ready to integrate
/// your local model, create a new class that implements this
/// interface and register it in the DI container.
abstract class AiModelDatasource {
  /// Generate a response given a system prompt (product context)
  /// and the user's message.
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
  });
}

/// Mock implementation that returns contextual pre-written responses.
/// Replace this with your local AI model implementation.
class MockAiModelDatasource implements AiModelDatasource {
  @override
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final query = userMessage.toLowerCase();

    if (query.contains('delivery') ||
        query.contains('track') ||
        query.contains('ship')) {
      return 'Based on the tracking data, your product has completed all processing stages and is currently in the distribution phase. '
          'The product was shipped from the manufacturing facility and should reach your location within 3-5 business days. '
          'You can track the delivery status in the tracking timeline section.';
    }

    if (query.contains('ingredient') ||
        query.contains('composition') ||
        query.contains('contain')) {
      return 'This product is made from 100% organic ingredients sourced directly from certified farms. '
          'All ingredients are processed following traditional Ayurvedic methods combined with modern quality control. '
          'Each batch is tested for purity and potency before packaging.';
    }

    if (query.contains('ayush') ||
        query.contains('license') ||
        query.contains('certif')) {
      return 'This product holds a valid AYUSH license, which certifies that it meets the quality and safety standards '
          'set by the Ministry of AYUSH, Government of India. You can verify the license authenticity by tapping '
          'the AYUSH License button on the product info page, which links to the official AYUSH portal.';
    }

    if (query.contains('expire') ||
        query.contains('expiry') ||
        query.contains('shelf')) {
      return 'The expiry date for this product is listed on the product tracking page. '
          'Ayurvedic products typically have a shelf life of 2-3 years when stored properly. '
          'Store in a cool, dry place away from direct sunlight for best results.';
    }

    if (query.contains('side effect') ||
        query.contains('safety') ||
        query.contains('dosage')) {
      return 'Please consult with a qualified Ayurvedic practitioner or your healthcare provider for personalized dosage recommendations. '
          'While Ayurvedic medicines are generally considered safe, individual responses may vary. '
          'Always follow the dosage instructions on the product label.';
    }

    if (query.contains('benefit') ||
        query.contains('use') ||
        query.contains('help')) {
      return 'This Ayurvedic product offers multiple health benefits rooted in traditional medicine. '
          'Check the AI Analytics section on the product info page for a detailed breakdown of the health benefits. '
          'For personalized advice, consult an Ayurvedic practitioner through the Doctor consultation feature.';
    }

    return 'Thank you for your question about this product! I can help you with information about:\n\n'
        '• **Delivery tracking** — current shipment status\n'
        '• **Ingredients** — composition and sourcing\n'
        '• **AYUSH License** — certification and authenticity\n'
        '• **Expiry & Storage** — shelf life information\n'
        '• **Health Benefits** — therapeutic properties\n'
        '• **Safety & Dosage** — usage guidelines\n\n'
        'Please ask about any of these topics and I\'ll provide detailed information!';
  }
}
