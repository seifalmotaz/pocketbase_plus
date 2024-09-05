
# Pocketbase Plus 🚀

Say goodbye to manual PocketBase model generation and let **Pocketbase Plus** do the heavy lifting! 😎

## How It Works

1. **Create a `pocketbase.yaml`** in your project.
2. Fill it with your secret sauce like this:
   ```yaml
   hosting:
     domain: {{YOUR POCKETBASE URL HERE}}
     email: {{ADMIN EMAIL}}
     password: {{ADMIN PASSWORD}}
   ```
3. **Install the package**: 
   ```bash
   dart pub global activate -s git https://github.com/seifalmotaz/pocketbase_plus
   ```
4. **Run the magic**: 
   ```bash
   pb_gen
   ```
And boom 💥! Your models are ready to roll!

Happy coding! ✨

## Next Steps

- Support for additional file types.
- Auto-generate CRUD functions directly within the models.
- Implement static `list` functions for fetching multiple records from the model.

More awesome features coming soon... Stay tuned!
