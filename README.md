# WorthIt

**Before you buy it, ask if itâ€™s worth it.**

WorthIt is a Flutter purchase decision assistant that helps users examine a purchase before committing to it. A guided questionnaire captures motivation, existing ownership, expected use, alternatives, impulse, and financial impact. Gemini, accessed through Firebase AI Logic, evaluates this context and returns a **Buy**, **Wait**, or **Donâ€™t Buy** verdict with an explanation and six factor scores.

The app combines a calm Material 3 interface, reactive GetX state management, a data-driven questionnaire, and structured AI responses.

> **Development status:** Active prototype. The main purchase-to-verdict flow is implemented in source. Decision persistence, history, insights, settings, and reminders are unfinished. This README describes the `master` source at commit [`6fa0d809a2be70254fdaa37cbe6038d3bae050ef`](https://github.com/i-Abdulhaseeb/WorthItApp/commit/6fa0d809a2be70254fdaa37cbe6038d3bae050ef); it does not certify a tested release. Some screens still use the earlier â€œVerdictâ€ branding.

## Contents

- [Features and implementation status](#features-and-implementation-status)
- [Purchase experience](#purchase-experience)
- [Technology stack](#technology-stack)
- [Architecture and source map](#architecture-and-source-map)
- [Questionnaire and answer lifecycle](#questionnaire-and-answer-lifecycle)
- [AI evaluation](#ai-evaluation)
- [Getting started](#getting-started)
- [Platform readiness](#platform-readiness)
- [Design system](#design-system)
- [Data handling](#data-handling)
- [Known limitations](#known-limitations)
- [Testing and development](#testing-and-development)
- [Suggested next milestones](#suggested-next-milestones)
- [Author and license](#author-and-license)

## Features and implementation status

| Area | Current implementation |
| --- | --- |
| Splash and navigation | Branded splash, three-second navigation delay, GetX named routes, and Home / Decisions / Insights / Settings tabs. |
| Home | Start-decision entry point, monthly summary layout, and sample recent decisions. Savings and avoidance figures are hardcoded; the decision count reads an in-memory list. |
| Product capture | Gallery image selection, manual product name and price, and product URL entry. All four values are currently required to advance. |
| Product overview | Product image, name, price, and an introduction to the evaluation. |
| Questionnaire | Six required single-choice questions, conditional follow-up inputs, contextual information, progress indicators, and an optional free-text step. |
| Answer review | Summary of the six selected answers and product details, including an entered alternative price. The product edit action is a placeholder. |
| AI analysis | Firebase AI Logic request with a JSON response schema; loading checklist, retry dialog, and limit-related error dialog. |
| Verdict | Dynamic verdict, reason, product summary, six score bars, and an arithmetic-average score badge. |
| Saved decisions | Save button, repository, controller, and history/detail screens exist as scaffolding; saving and retrieval are not implemented. |
| Insights and feedback | Models and supporting widgets exist; the main screens remain placeholders. |
| Settings | Placeholder screen and reactive preference fields; no working settings persistence or theme switching. |
| Storage and reminders | `HiveService` and `NotificationService` are stubs. Their names do not indicate working database or notification integrations. |

## Purchase experience

1. Open the app and select **Start a decision** on Home.
2. Choose a gallery image, enter a product name and price, and paste a product link.
3. Review the product overview and continue to the questionnaire.
4. Answer the six required questions. When a cheaper alternative exists, optionally enter its name and price.
5. Enter optional context, or leave it empty and select **Continue to Review**.
6. Review the answer summary and select **Analyze my purchase**.
7. Read the returned verdict, explanation, and factor scores.

For the current prototype, enter a plain whole-number price such as `15000`. Some question-screen calculations use `int.parse`, so commas, currency symbols, and decimal input can cause errors even though the AI service separately normalizes prices.

The four analysis checks are **Understanding purchase**, **Checking affordability**, **Comparing alternatives**, and **Evaluating long-term value**. They advance on a timer while one AI request runs. They are presentation states, not separate backend operations or live product searches. A successful response completes the checklist and opens the verdict immediately.

## Technology stack

Versions below are the constraints declared in `pubspec.yaml`, rather than claims about the latest available releases.

| Technology | Version / configuration | Purpose |
| --- | --- | --- |
| Flutter | Lockfile requires `>=3.44.0` | Application UI and platform runners |
| Dart | `^3.13.0` | Application language |
| GetX | `^4.7.3` | Reactive state, dependency registration, routing, dialogs |
| Google Fonts | `^8.2.1` | Inter and Playfair Display typography |
| Image Picker | `^1.2.3` | Gallery image selection |
| Firebase Core | `^4.15.0` | Firebase initialization |
| Firebase AI | `^4.0.0` | Gemini requests through Firebase AI Logic |
| Firebase App Check | `^0.4.8` | App Check integration; Android debug provider currently configured |
| Cupertino Icons | `^1.0.8` | Icon assets |
| Flutter Test / Flutter Lints | SDK / `^6.0.0` | Widget testing and static analysis |

The package version is `1.0.0+1`. The active dependency manifest does **not** include Hive, Dio, Firebase Auth, or a local notifications package. There is no separate application backend in this repository.

## Architecture and source map

WorthIt uses feature-oriented folders with GetX controllers and views. Shared services, question definitions, models, and theme configuration sit outside the individual features. Repository classes define future persistence boundaries, but currently contain little or no implementation.

| Path | Responsibility |
| --- | --- |
| `lib/main.dart` | Initializes Firebase and App Check, then starts `GetMaterialApp`. |
| `lib/app/bindings/initial_binding.dart` | Registers the main tab controllers. |
| `lib/app/routes/` | Named route constants, page definitions, and route-level bindings. |
| `lib/app/theme/` | Semantic colors, typography, and Material 3 light theme. |
| `lib/core/question_engine/question_templates.dart` | Question definitions, option IDs, follow-up fields, and helper lookups. |
| `lib/core/question_engine/answer_interpretation.dart` | Maps selected option IDs to descriptive context for Gemini. |
| `lib/core/services/gemini_service.dart` | Builds the prompt, defines the response schema, and invokes the model. |
| `lib/core/services/` and `lib/core/storage/` | Additional image, notification, and storage service scaffolding. |
| `lib/core/utils/` | Currency/date formatting and input validator helpers. |
| `lib/core/widget/bottom_nav_bar.dart` | Four-tab application shell. |
| `lib/data/models/` | Question, answer, purchase, AI decision, feedback, and profile types. |
| `lib/data/repositories/` | Placeholder persistence interfaces for purchases, decisions, feedback, and profiles. |
| `lib/features/purchase/` | Product input, questions, review, analysis, verdict, and supporting widgets. |
| `lib/features/home/` and `lib/features/splash/` | Home and startup experiences. |
| `lib/features/decisions/`, `insights/`, `feedback/`, `settings/` | Feature scaffolding and reusable UI pieces. |
| `lib/firebase_options.dart` | Generated Firebase options for Android and web. |
| `assets/images/splash_logo.png` | Branded splash artwork. |
| `test/widget_test.dart` | Splash and tab-navigation smoke test. |
| `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` | Flutter platform runners; readiness varies by platform. |

### Controller responsibilities

- **`PurchaseController`** owns product fields, gallery selection, input dialogs, and the gate into product details.
- **`QuestionController`** owns the current question, editable answer maps, text controllers, follow-up values, and the in-memory `DecisionFlowAnswers` object.
- **`AnalysisController`** starts the AI request and loading timer, parses JSON into reactive fields, handles errors and retries, and navigates to the verdict.
- **`GeminiService`** uses the Google AI backend through `FirebaseAI.googleAI()` and obtains controller data through explicit arguments or GetX lookup.

`DecisionResult` and `DecisionScores` provide typed response models, although the active analysis controller currently reads the decoded map directly. The files `question_engine.dart` and `question_rules.dart` are empty placeholders; current questionnaire behavior lives in the templates, view, and controller.

## Questionnaire and answer lifecycle

| Question ID | Evaluates | Input |
| --- | --- | --- |
| `motivation` | Need, replacement, upgrade, convenience, hobby, or desire | Single choice |
| `already_own_similar` | Existing ownership and possible redundancy | Single choice |
| `usage_frequency` | Expected practical use | Single choice |
| `cheaper_alternative` | Whether a cheaper option could meet the need | Single choice; optional alternative name and price |
| `how_long_wanted` | How long the desire has persisted | Single choice |
| `financial_impact` | Impact on financial commitments | Single choice |
| `clarifying_intent` | Additional context in the user's own words | Optional free text, configured with a 300-character limit and quick prompts |

Selections first enter reactive editing maps. **Continue** commits the current answer to `DecisionFlowAnswers`, keyed by question ID. Answers can include an option ID, follow-up values, free text, skipped status, and an answer timestamp. The flow also records product metadata and start/completion timestamps. The answer models support JSON serialization, but no durable storage is connected.

Changing an option clears that question's previous follow-up values. The UI also calculates potential savings against a cheaper alternative and an approximate work-hours equivalent:

```text
hourly income = monthly income / (weekly work hours Ã— 4)
work hours for purchase = round(product price / hourly income)
```

The current monthly income is fixed at **PKR 120,000**, with **40 working hours per week**. These are development defaults, not values collected from the user or a saved profile.

## AI evaluation

### Request construction

`GeminiService.analyzePurchase()` sends a text prompt containing:

- Product name, normalized price, currency (`PKR`), and the entered URL.
- The fixed monthly income and weekly work-hours values.
- The six core question IDs, selected option IDs, and their human-readable interpretations.
- Verdict definitions, scoring instructions, and writing rules for the explanation and recommendation.

The selected image, alternative name/price, and optional `clarifying_intent` text are **not currently included** in the AI request. A pasted URL is supplied as text; the app does not implement URL scraping, price retrieval, search grounding, or image recognition.

The active service specifies `gemini-3.6-flash`, temperature `0.2`, and `application/json` output. This is the model identifier committed in the code; availability must be checked against the Firebase project used to run the app. The older model name in `lib/core/constants/gemini_constants.dart` is unused by this service.

### Response contract

The response schema requires `verdict`, `reason`, `scores`, and `recommendation`. The following is an illustrative payload, not a recorded model result:

```json
{
  "verdict": "wait",
  "reason": "Your current product still meets your needs, and the purchase would delay a financial goal. Frequent expected use supports its value, but does not resolve that trade-off.",
  "scores": {
    "affordability": 45,
    "necessity": 30,
    "value": 55,
    "usage": 85,
    "alternative": 35,
    "impulse_risk": 65
  },
  "recommendation": "Compare the cheaper option and set aside the purchase amount without reducing money reserved for your goal. Reassess when you can identify a limitation your current product cannot address."
}
```

| Field | Meaning |
| --- | --- |
| `verdict` | Exactly `buy`, `wait`, or `dont_buy`. |
| `reason` | Explanation of the factors behind the verdict. |
| `affordability` | Higher means easier to afford. |
| `necessity` | Higher means more necessary. |
| `value` | Higher means better value for the price. |
| `usage` | Higher means more frequent expected use. |
| `alternative` | Higher means no meaningful cheaper alternative. |
| `impulse_risk` | Higher means **greater risk**, unlike the favorable direction of the other scores. |
| `recommendation` | Suggested next action and relevant trade-offs. |

The prompt asks for integer scores from 0â€“100. The schema declares integers, but the controller does not enforce those numeric bounds after parsing. These scores are model-generated judgments, not calibrated probabilities or outputs of a deterministic financial model.

The verdict screen displays the reason and uses the recommendation only as a fallback when the reason is empty. A separate recommendation section has not yet been implemented.

### Loading and errors

The checklist advances every 1,400 milliseconds. It can reach 100% while the request is still pending; successful parsing triggers navigation. Errors containing terms such as `quota`, `daily`, `limit`, or `resource_exhausted` open the limit dialog. Other errors open the busy dialog with a manual retry action. This string-based classification does not reliably distinguish every server, configuration, network, or parsing error, and does not establish a quota reset time.

## Getting started

### 1. Prepare the development environment

Use a Flutter SDK satisfying the committed lockfile's `>=3.44.0` requirement and the Dart constraint `>=3.13.0 <4.0.0`. Android development also requires an Android SDK, a compatible JDK, and an emulator or physical device.

The Android source currently declares:

| Setting | Committed value |
| --- | --- |
| Application ID / namespace | `com.example.worthitapp` |
| Android Gradle Plugin | `9.1.0` |
| Gradle wrapper | `9.3.1` |
| Kotlin plugin declaration | `2.4.0` |
| Google Services plugin | `4.4.4` |
| Java / Kotlin compilation target | Java 17 / JVM 17 |
| Android SDK levels | Delegated to Flutter's SDK defaults |

Java 17 is the configured compilation target; use a JDK compatible with the selected Gradle and Android Gradle Plugin versions. The repository also sets `android.newDsl=false` and `android.builtInKotlin=false`.

```bash
git clone https://github.com/i-Abdulhaseeb/WorthItApp.git
cd WorthItApp
flutter --version
flutter doctor
flutter pub get
```

### 2. Configure Firebase

The repository contains Firebase configuration for its original project. For an independent setup, configure a project you control:

1. Register an Android app matching your application ID.
2. Configure Firebase AI Logic with the Google AI backend and confirm that the chosen model is available to your project.
3. With the Firebase CLI installed and authenticated, install and run FlutterFire CLI from the repository root:

```bash
dart pub global activate flutterfire_cli
 flutterfire configure
```

4. Select your Firebase project and intended platforms. Ensure `lib/firebase_options.dart` and `android/app/google-services.json` correspond to that project and package name.
5. If needed, update the active `model:` value in `lib/core/services/gemini_service.dart` to a model available through your configured backend.

There is no `.env` loader or standalone Gemini API-key input in the active Dart implementation. Startup uses `DefaultFirebaseOptions.currentPlatform`.

### 3. Configure App Check for development

`lib/main.dart` currently activates `AndroidDebugProvider`. When using Firebase App Check enforcement, register the debug token printed by the local Android build in your Firebase project's App Check configuration. Keep this token private.

Before distributing the application, replace or conditionally select the debug provider with an appropriate production provider and test the resulting configuration.

### 4. Run on Android

```bash
flutter devices
flutter run -d <android-device-id>
```

Replace `<android-device-id>` with an ID returned by `flutter devices`. An internet connection and working Firebase/model configuration are needed for AI analysis.

For a local debug APK:

```bash
flutter build apk --debug
```

Release distribution needs additional configuration: the current release build uses debug signing. The main Android manifest also does not explicitly declare `INTERNET`, while the debug/profile manifests do; verify the merged release manifest includes it before validating release AI requests.

## Platform readiness

| Platform | Source-level readiness |
| --- | --- |
| Android | Firebase options, Google Services configuration, and debug App Check integration are present. Primary development path; builds were not executed for this documentation review. |
| Web | Firebase options exist, but purchase screens use `dart:io`, `File`, and `Image.file`; image handling and web App Check setup require adaptation before claiming support. |
| iOS | Runner exists, but generated Firebase options throw `UnsupportedError`. Firebase setup and photo-library permission configuration are still needed. |
| macOS, Windows, Linux | Runner scaffolding exists; generated Firebase options throw `UnsupportedError`. Platform-specific dependency and runtime support still require validation. |

## Design system

The theme is named **Decision-Oriented Minimalism** and uses Material 3, light surfaces, emerald actions, rounded cards, and subdued borders. Inter is the primary typeface; the Home screen also uses Playfair Display.

| Token | Value | Role |
| --- | --- | --- |
| Background / surface | `#FCF9F8` | Warm light canvas |
| Lowest container | `#FFFFFF` | Cards |
| Primary | `#006948` | Main brand green |
| Primary emerald | `#059669` | Action and emphasis color |
| On surface | `#1C1B1B` | Main text |
| Secondary | `#904D00` | Amber semantic color |
| Tertiary | `#BB0112` | Red semantic color |

Custom painters provide splash decorations, the analysis illustration, and error-dialog artwork. Some views still define local colors and styles alongside the shared theme.

## Data handling

The current implementation holds product and questionnaire state in memory. JSON serialization support exists, but the storage services and repositories do not persist it across restarts. The app has no implemented sign-in flow or account synchronization.

AI evaluation sends the product metadata, fixed financial defaults, and six selected answers with interpretations to Gemini through Firebase AI Logic. The selected gallery image is displayed locally and is not attached to that request. Some UI copy says responses remain on-device; that wording does not describe the current AI data flow and should be corrected.

Development logging prints saved answers and analysis/error information. Review that logging before distributing builds intended for real user data.

## Known limitations

These findings come from source inspection and describe areas that still need implementation or validation:

- **Input requirements:** Although the capture screen presents separate input cards, navigation requires image, name, price, and link together. Input validation is limited, and the shared validators are not wired into these dialogs.
- **Optional-step navigation:** The final step's **Skip for now** path marks completion but does not navigate to review. Leaving the field blank and pressing **Continue to Review** follows the implemented review path.
- **AI context coverage:** Alternative details and optional free text are collected but omitted from the prompt. The model also receives fixed income/work-hour defaults rather than a real financial profile.
- **Score interpretation:** The overall badge averages all six raw values, including impulse risk. Higher risk therefore increases that average, and the factor-color helper also colors high risk green. This needs correction before treating the badge as purchase suitability.
- **Repeated analyses:** `AnalysisController` is registered as permanent and starts its request in `onInit`. Entering analysis again with an existing controller may retain an earlier result instead of starting a fresh request; a reset/start lifecycle is needed.
- **Request resilience:** No explicit timeout, cancellation, or automatic backoff is applied to the model call. The timeout constant exists but is unused in this path.
- **Incomplete actions:** Save Decision, review-product editing, and several feature screens are placeholders. Error-dialog wording about saved progress should not be interpreted as durable storage.
- **Prototype content:** Home statistics and recent decisions include sample values. Some question help text remains headphone-specific, and the review screen's sub-five-second timing claim is static copy.
- **Prompt consistency:** Detailed writing instructions coexist with requests for a â€œconciseâ€ reason and recommendation. Response length is not controlled consistently.

## Testing and development

Run these checks in a configured Flutter environment:

```bash
flutter analyze
flutter test
```

The existing widget test covers the splash and navigation to the main tabs. Its Home assertion expects `Good Morning`, while the current Home view displays `Good morning`, so that assertion needs alignment. The test does not validate the live Gemini request or the full purchase flow.

This README was prepared through static source review. Flutter was unavailable in the review environment, so no build, analyzer run, widget test execution, or live Firebase request is claimed.

Useful next test coverage includes answer serialization, optional-step navigation, numeric input validation, response parsing and bounds, retry behavior, and starting multiple decisions without stale state. Use a fake AI service for deterministic tests.

When extending the code:

- Keep question and option IDs synchronized between templates and answer interpretations.
- Explicitly add new question data to the AI payload; template additions alone do not expand the hardcoded six-question request list.
- Update the schema, parsing, model classes, and verdict UI together when changing the response contract.
- Implement storage behind the existing repositories and connect the save action before presenting history as a completed feature.
- Prefer the shared theme tokens when adding screens.

## Suggested next milestones

The following are development priorities inferred from the existing scaffolding and gaps, rather than committed release dates:

- [ ] Finish product validation, optional-step navigation, and per-purchase controller reset behavior.
- [ ] Include optional context and alternative details in the AI request.
- [ ] Replace financial defaults with an editable, persisted profile.
- [ ] Correct impulse-risk aggregation and coloring; display the recommendation separately.
- [ ] Implement decision saving, retrieval, and history details.
- [ ] Replace dashboard samples with actual saved-decision statistics.
- [ ] Complete insights, feedback, preferences, and cooling-off reminders.
- [ ] Add deterministic flow tests and AI failure-path tests.
- [ ] Align privacy copy, configure production App Check and signing, and validate release builds.
- [ ] Configure and test additional platforms before documenting them as supported.

## Author and license

Developed by **Abdul Haseeb** â€” [i-Abdulhaseeb on GitHub](https://github.com/i-Abdulhaseeb).

Repository: [i-Abdulhaseeb/WorthItApp](https://github.com/i-Abdulhaseeb/WorthItApp).

No license file is present in the reviewed repository. A license should be added to make reuse and distribution terms explicit.
