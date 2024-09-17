
# Pocketbase Plus 🚀

Say goodbye to manual PocketBase model generation and let **Pocketbase Plus** do the heavy lifting! 😎

## Installation inside your project

install as dev dependency with:


   ```bash
   dart pub add 'dev:pocketbase_plus:{"git":"https://github.com/seifalmotaz/pocketbase_plus"}'   
   ```
   or
   ```bash
   dart pub add dev:pocketbase_plus
   ```

## How It Works

1. **Create a `pocketbase.yaml`** in your project or directly inside your `pubspec.yaml`.
2. Fill it with your secret sauce like this:
```yaml
pocketbase:
  hosting:
    domain: 'https://your-pocketbase-domain.com'
    email: 'your-email@example.com'
    password: 'your-password'
  output_directory: './lib/models'  # Optional, default is './lib/models'
```

4. **Run the magic**:

```bash
dart run pocketbase_plus:main
```

You can specify the configuration file path (e.g.: your pubspec.yaml) using the --config or -c option:
```bash
dart run pocketbase_plus:main --config pubspec.yaml
```

And boom 💥! Your models are ready to roll!

Happy coding! ✨

## Next Steps

- Support for additional file types.
- Auto-generate CRUD functions directly within the models.
- Implement static `list` functions for fetching multiple records from the model.

More awesome features coming soon... Stay tuned!
