import 'package:flutter/foundation.dart';

import 'smart_management.dart';

/// JuneInterface allows any auxiliary package to be merged into the "June"
/// class through extensions
abstract class JuneInterface {
  IntelligentManagement intelligentManagement = IntelligentManagement.full;
}
