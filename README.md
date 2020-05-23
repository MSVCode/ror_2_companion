# Risk of Rain 2 Companion

Risk of Rain 2 Companion is third-party open-sourced Flutter-based application. This project is started as a fun project to accompany players while playing Risk of Rain 2.

This repository is created to make it easier for others to contribute to this project.

## Build Instructions

- Install Flutter: https://flutter.dev/docs/get-started/install
- Install Android SDK version 28 via SDK manager
- Compile and run using your preferred editor (Android Studio or VisualStudio Code)

## Contributing

You can contribute to this project by creating an issue or a Pull Request.

All data provided by this app is crowd-sourced, so there might be some errors. You could help us to improve the data by contributing.

### Data Location

The data used by this project are JSON files (location: `<project folder>/asset/json`). 

Any new images might be added to:
- `<project folder>/asset/image`: For open-sourced image assets
- `<project folder>/asset/gameAsset`: For non-free/non-open-sourced/copyrighted game asset images (from Risk of Rain 2)

Notes about data:
- ID >= `10000` are used for items with currently unknown in-game id (let us know the ID to update them)
- `damage`, `heal`, `procChance` are currently unused, might be used for future releases

### Contributing Language Translation
You can help contribute translations to this app by creating translation files.

How it works:
1. The app will load `asset/json/core` data as base data
2. If user set translation in setting other than `Default (English)`, `DataProvider` will load translation data
3. It will try to access `asset/json/[translation_name]` folder and load the translation file
4. Base data will be replaced with keys fron translation data

How to contribute:
1. Create a new folder for language you translating in `asset/json/[translation_code]`, e.g `asset/json/id`
2. Copy json data from `asset/json/sample_en` for the base
3. Edit all data except `id`, `key`, `type`, `skillType`, or `variant`
4. Submit a pull request

## Disclaimer

This application is not affiliated with, endorsed, sponsored, or specifically approved by Hopoo Games nor Gearbox Publishing.
Therefore, Hopoo Games and Gearbox Publishing are not responsible for this app.

Any Game content and assets are trademarks and copyrights of their respective publisher and its licensors and not included in [Risk of Rain 2 Companion]'s license.

## License

MIT License with extra clause.

While Risk of Rain 2 Companion's code is MIT license, you're not allowed to re-release this application anywhere. However, you may create an entirely new app (e.g. companion app for other game) using codes from this repository.