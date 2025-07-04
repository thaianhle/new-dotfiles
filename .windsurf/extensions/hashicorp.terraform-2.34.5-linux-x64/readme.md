# Terraform Extension for Visual Studio Code

The HashiCorp [Terraform Extension for Visual Studio Code (VS Code)](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) with the [Terraform Language Server](https://github.com/hashicorp/terraform-ls) adds editing features for [Terraform](https://www.terraform.io) and Terraform Stacks files such as syntax highlighting, IntelliSense, code navigation, code formatting, module explorer and much more!

## Quick Start

Get started writing Terraform configurations with VS Code in three steps:

- **Step 1:** If you haven't done so already, install [Terraform](https://www.terraform.io/downloads)

- **Step 2:** Install the [Terraform Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).

- **Step 3:** To activate the extension, open any folder or VS Code workspace containing Terraform or Terraform Stacks files. Once activated, the Terraform language indicator will appear in the bottom right corner of the window.

New to Terraform? Read the [Terraform Learning guides](https://learn.hashicorp.com/terraform)

See [Usage](#usage) for more detailed getting started information.

Read the [Troubleshooting Guide](#troubleshooting) for answers to common questions.

## Features

This extension provides both Terraform and Terraform Stacks language features. For most features Terraform Stacks support is implied, specific functionality is called out where approprite.

- [IntelliSense](#intellisense-and-autocomplete) Edit your code with auto-completion of providers, resource names, data sources, attributes, components and more
- [Syntax validation](#syntax-validation) Provides inline diagnostics for invalid configurations as you type
- [Syntax highlighting](#syntax-highlighting) Highlighting syntax for Terraform 0.12 to 1.X and Terraform Stacks
- [Code Navigation](#code-navigation) Navigate through your codebase with Go to Definition and Symbol support
- [Code Formatting](#code-formatting) Format your code with `terraform fmt` automatically
- [Code Snippets](#code-snippets) Shortcuts for common snippets like `for_each` and `variable`
- [HCP Terraform Integration](#hcp-terraform-integration) View HCP Terraform Workspaces and Run details inside VS Code
- [Terraform Module Explorer](#terraform-module-and-provider-explorer) View all modules and providers referenced in the currently open document.
- [Terraform commands](#terraform-commands) Directly execute commands like `terraform init` or `terraform plan` from the VS Code Command Palette.

### IntelliSense and Autocomplete

The Terraform Extension for VS Code provides IntelliSense support for Terraform and for Terraform Stacks.

IntelliSense is a general term for a variety of code editing features including: code completion, parameter info, quick info, and member lists. IntelliSense features are sometimes called by other names such as autocomplete, code completion, and code hinting.

For Terraform constructs like resource and data, labels, blocks and attributes are auto completed both at the root of the document and inside other blocks. This also works for Terraform modules that are installed in the workspace, attributes and other constructs are autocompleted.

For Terraform Stacks constructs like component and resource, blocks and attributes are auto completed both at the root of the document and inside other blocks. This also works for Terraform Stack components that are installed in the workspace, attributes and other constructs are autocompleted.

This means that you can benefit from auto-completion, parameter info, quick info, and member lists when working with both Terraform and Terraform Stacks files. Whether you're defining stacks, resources, or variables, the extension will provide context-specific completions to help you write your code more efficiently.

> **Note:** If there are syntax errors present in the document upon opening, intellisense may not provide all completions. Please fix the errors and reload the document and intellisense will return. See [hcl-lang#57](https://github.com/hashicorp/hcl-lang/issues/57) for more information.

Invoking intellisense is performed through the [keyboard combination](https://code.visualstudio.com/docs/getstarted/keybindings) for your platform and the results depend on where the cursor is placed.

If the cursor is at the beginning of a line and no other characters are present, then a list of constructs like `data`, `provider`, `resource`, etc are shown.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/intellisense1.png)

If inside a set of quotes or inside a block, the extension provides context specific completions appropriate for the location. For example, inside a `resource` block attributes for a given provider are listed.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/intellisense2.png)

Combining `editor.suggest.preview` with the [pre-fill required fields](#code-completion) setting will provide inline snippet suggestions for blocks of code:

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/intellisense3.png)

Completing the snippet allows you to tab complete through each attribute and block.

### Syntax Validation

Terraform and Terraform Stacks configuration files are validated when opened and on change, and invalid code is marked with diagnostics.

HCL syntax is checked for e.g. missing control characters like `}`, `"` or others in the wrong place.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/validation-rule-hcl.png)

Enhanced validation of selected Terraform language constructs in both `*.tf` and `*.tfvars` files based on detected Terraform version and provider versions is also provided. This also works for Terraform Stacks language constructs in `*.tfcomponent.hcl`, `*.tfstack.hcl` and `*.tfdeploy.hcl` files.

This can highlight deprecations, missing required attributes or blocks, references to undeclared variables and more, [as documented](https://github.com/hashicorp/terraform-ls/blob/main/docs/validation.md#enhanced-validation).

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/validation-rule-missing-attribute.png)

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/validation-rule-invalid-ref.png)

The enhanced validation feature is enabled by default but can be disabled using the following setting:

```json
"terraform.validation.enableEnhancedValidation": false
```

The extension also provides validation through [`terraform validate`](https://www.terraform.io/cli/commands/validate). This can be triggered via command palette. Unlike the other validation methods, this one requires the Terraform CLI installed and a previous successful run of `terraform init` (i.e. local installation of all providers and modules) to function correctly. It is the slowest method, but the most thorough - i.e. it will catch the most mistakes.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/validation-cli-command.png)

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/validation-cli-diagnostic.png)

### Syntax Highlighting

Terraform syntax highlighting recognizes language constructs from Terraform version 0.12 to 1.X. Terraform providers, modules, variables and other high-level constructs are recognized, as well as more complex code statements like `for` loops, conditional expressions, and other complex expressions.

Terraform Stacks syntax highlighting recognizes language constructs from Terraform version 1.9 to 1.X.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/syntax.png)

Some language constructs will highlight differently for older versions of Terraform that are incompatible with newer ways of expressing Terraform code. In these cases we lean toward ensuring the latest version of Terraform displays correctly and do our best with older versions.

### Code Navigation

While editing, you can right-click different identifiers in Terraform and Terraform Stacks files to take advantage of several convenient commands:

- `Go to Definition` (`F12`) navigates to the code that defines the construct where your cursor is. This command is helpful when you're working with Terraform modules and variables defined in other files than the currently opened document.
- `Peek Definition` (`Alt+F12`) displays the relevant code snippet for the construct where your cursor is directly in the current editor instead of navigating to another file.
- `Go to Declaration` navigates to the place where the variable or other construct is declared.
- `Peek Declaration` displays the declaration directly inside the current editor.

### Code Formatting

This extension utilizes [`terraform fmt`](https://www.terraform.io/cli/commands/fmt) to rewrite an open document to a canonical format and style. This command applies a subset of the [Terraform language style conventions](https://www.terraform.io/language/syntax/style), along with other minor adjustments for readability.

This works for both Terraform and Terraform Stacks files.

See the [Formatting](#formatting) Configuration section for information on how to configure this feature.

### Code Snippets

The extension provides context aware snippets to accelerate adding Terraform code to your configuration files.

Combined with `editor.suggest.preview` and `terraform.experimentalFeatures.prefillRequiredFields`, the extension can suggest completions for all Terraform language constructs.

### HCP Terraform Integration

Every time you have to switch away from your code, you risk losing momentum and the context about your tasks. Previously, Terraform users needed to have at least two windows open – their editor and a web page – to develop Terraform code. The editor contains all of the Terraform code they are working on, and the web page has the HCP Terraform workspace loaded. Switching back and forth between the HCP Terraform website and the text editor can be a frustrating and fragmented experience.

The HCP Terraform Visual Studio Code integration improves user experience by allowing users to view workspaces directly from within Visual Studio Code. Users can view the status of current and past runs and inspect detailed logs – without ever leaving the comfort of their editor.

To start using HCP Terraform with VS Code, open the new HCP Terraform sidebar and click "Login to HCP Terraform". You can login using a stored token from the Terraform CLI, an existing token you provide, or open the HCP Terraform website to generate a new token.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/tfc/login_view.gif)

Once logged in, you are prompted to choose which Organization to view workspaces in.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/tfc/choose_org_view.png)

Now that your Organization is chosen, the Workspace view populates with all workspaces your token has permission to view. At a glance, you can see the last run status of each Workspace. Hovering over a workspace shows detailed information about each workspace.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/tfc/workspace_view.gif)

Selecting a workspace populates the Run view with a list of runs for that workspace. At a glance, you can see the status of each Run, and hover over each for more detailed information.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/tfc/workspace_run_view.gif)

If a Run has been Planned or Applied, you can view the raw log for each by expanding the Run then selecting the 'View Raw Log' button for either the Plan or Apply.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/tfc/plan_apply_view.gif)

To sign out or log out of your HCP Terraform session, click the Accounts icon next to the Settings icon in the Activity Bar and select "Sign Out":

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/tfc/log_out.png)

This will clear the currently saved token and allow you to login using a different token.

### Terraform Module and Provider Explorer

List Terraform modules used in the current open document in the Explorer Pane, or drag to the Side Bar pane for an expanded view.

Each item shows an icon indicating where the module comes from (local filesystem, git repository, or Terraform Registry).

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/module_calls.png)

If the module comes from the Terraform Registry, a link to open the documentation in a browser is provided.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/module_calls_doc_link.png)

List Terraform providers used in the current open document in the Explorer Pane, or drag to the Side Bar pane for an expanded view.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/module_providers.png)

### Terraform Commands

The extension provides access to several Terraform commands through the Command Palette:

- Terraform: init
- Terraform: init current folder
- Terraform: validate
- Terraform: plan

## Requirements

The Terraform VS Code extension bundles the [Terraform Language Server](https://github.com/hashicorp/terraform-ls) and is a self-contained install.

The extension does require the following to be installed before use:

- VS Code v1.86 or greater
- Terraform v0.12 or greater

## Platform Support

The extension should work anywhere VS Code itself and Terraform 0.12 or higher is supported. Our test matrix includes the following:

- Windows Server 2022 with Terraform v1.6
- macOS 12 with Terraform v1.6
- macOS 11 with Terraform v1.6
- Ubuntu 22.04 with Terraform v1.6

Intellisense, error checking and other language features are supported for Terraform v0.12 and greater.

Syntax highlighting targets Terraform v1.0 and greater. Highlighting 0.12-0.15 configuration is done on a best effort basis.

## Usage

### VS Code Workspace support

It is a common pattern to have separate folders containing related Terraform configuration that are not contained under one root folder. For example, you have a main Terraform folder containing the configuration for a single application and several module folders containing encapsulated code for configuring different parts of component pieces. You could open each folder in a separate VS Code window, and bounce between each window to author your changes.

A better approach is to use [VS Code Workspaces](https://code.visualstudio.com/docs/editor/workspaces). Using our example above, open the main Terraform folder first, then use Add Folder to workspace to add the dependent module folders. A single VS Code window is used and all Terraform files are available to author your changes. This uses a single terraform-ls process that has an understanding of your entire project, allowing you to use features like `Go to Symbol` and `Reference counts` across your project.

### Single file support

Opening a single Terraform configuration file inside VS Code is currently not supported. We see this approach most commonly attempted by users of terminal editors like vim, where it is common to edit a single file at a time.

The Terraform VS Code extension works best when it has the full context of a Terraform project where it can parse the referenced files and provide the expected advanced language features.

The recommended workflow is to instead open the containing folder for the desired Terraform file inside a single VS Code editor window, then navigate to the desired file. This seems counter-intuitive when you only want to edit a single file, but this allows the extension to understand the Terraform setup you are using and provide accurate and helpful intellisense, error checking, and other language features.

### Refresh Intellisense

The extension will pick up new schema for Terraform providers you reference in your configuration files automatically whenever anything changes inside `.terraform`.

To provide the extension with an up-to-date schema for the Terraform providers used in your configuration:

1. Open any folder or VS Code workspace containing Terraform files. 
1. Open the Command Palette and run `Terraform: init current folder` or perform a `terraform init` from the terminal.

### Remote Extension support

The Visual Studio Code [Remote - WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) lets you use the Windows Subsystem for Linux (WSL) as your full-time development environment right from VS Code. You can author Terraform configuration files in a Linux-based environment, use Linux-specific toolchains and utilities from the comfort of Windows.

The Remote WSL extension runs the [HashiCorp Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) and other extensions directly in WSL so you can edit files located in WSL or the mounted Windows filesystem (for example /mnt/c) without worrying about pathing issues, binary compatibility, or other cross-OS challenges.

For a detailed walkthrough for how to get started using WSL and VS Code, see https://code.visualstudio.com/docs/remote/wsl-tutorial.

## Configuration

The extension does not require any initial configuration and should work out of the box. To take advantage of additional VS Code features or experimental extension features you can configure settings to customize behavior.

This extension offers several configuration options. To modify these open the [VS Code Settings Editor](https://code.visualstudio.com/docs/getstarted/settings#_settings-editor) in the UI or JSON view for [user and workspace level](https://code.visualstudio.com/docs/getstarted/settings#_creating-user-and-workspace-settings) settings, [scope your settings by language](https://code.visualstudio.com/docs/getstarted/settings#_languagespecific-editor-settings), or alternatively modify the `.vscode/settings.json` file in the root of your working directory.

### Code Completion

An experimental option can be enabled to prefill required fields when completing Terraform blocks with the following setting:

```json
"terraform.experimentalFeatures.prefillRequiredFields": true
```

For example, choosing `aws_alb_listener` in the following block inserts a snippet in the current line with the `resource` block entirely filled out, containing tab stops to fill in the required values.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/pre-fill.png)

Combine this with `editor.suggest.preview` and the editor will provide inline snippet suggestions for blocks of code:

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/intellisense3.png)

Completing the snippet allows you to tab complete through each attribute and block.

### Code Lens

Display reference counts above top level blocks and attributes

```json
"terraform.codelens.referenceCount": true
```

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/code_lens.png)

> **Note:** This feature impacts extension performance when opening folders with many modules present. If you experience slowness or high CPU utilization, open a smaller set of folders or disable this setting.

### Formatting

To enable automatic formatting, it is recommended that the following be added to the extension settings for the Terraform extension:

```json
"[terraform]": {
  "editor.defaultFormatter": "hashicorp.terraform",
  "editor.formatOnSave": true,
  "editor.formatOnSaveMode": "file"
},
"[terraform-vars]": {
  "editor.defaultFormatter": "hashicorp.terraform",
  "editor.formatOnSave": true,
  "editor.formatOnSaveMode": "file"
}
```

> It is recommended to set `editor.defaultFormatter` to ensure that VS Code knows which extension to use to format your files. It is possible to have more than one extension installed which claim a capability to format Terraform files.

When using the `editor.formatOnSaveMode` setting, only `file` is currently supported. The `modifications` or `modificationsIfAvailable` settings [use the currently configured SCM](https://code.visualstudio.com/updates/v1_49#_only-format-modified-text) to detect file line ranges that have changed and send those ranges to the formatter. The `file` setting works because `terraform fmt` was originally designed for formatting an entire file, not ranges. If you don't have an SCM enabled for the files you are editing, `modifications` won't work at all. The `modificationsIfAvailable` setting will fall back to `file` if there is no SCM and will appear to work sometimes.

If you want to use `editor.codeActionsOnSave` with `editor.formatOnSave` to automatically format Terraform files, use the following configuration:

```json
"editor.formatOnSave": true,
"[terraform]": {
  "editor.defaultFormatter": "hashicorp.terraform",
  "editor.formatOnSave": false,
  "editor.codeActionsOnSave": {
    "source.formatAll.terraform": true
  },
},
"[terraform-vars]": {
  "editor.defaultFormatter": "hashicorp.terraform",
  "editor.formatOnSave": false,
  "editor.codeActionsOnSave": {
    "source.formatAll.terraform": true
  },
}
```

This will keep the global `editor.formatOnSave` for other languages you use, and configure the Terraform extension to only format during a `codeAction` sweep.

> **Note**: Ensure that the terraform binary is present in the environment `PATH` variable. If the terraform binary cannot be found, formatting will silently fail.

### Validation

An experimental validate-on-save option can be enabled with the following setting:

```json
"terraform.experimentalFeatures.validateOnSave": true
```

This will create diagnostics for any elements that fail validation. You can also run `terraform validate` by issuing the `Terraform: validate` in the command palette.

### Multiple Workspaces

If you have multiple root modules in your workspace, you can configure the language server settings to identify them. Edit this through the VSCode Settings UI or add a `.vscode/settings.json` file using the following template:

```json
"terraform.languageServer.rootModules": [
  "/module1",
  "/module2"
]
```

If you want to automatically search root modules in your workspace and exclude some folders, you can configure the language server settings to identify them.

```json
"terraform.languageServer.excludeRootModules": [
  "/module3",
  "/module4"
]
```

If you want to automatically ignore certain directories when terraform-ls indexes files, add the folder names to this setting:

```json
 "terraform.languageServer.ignoreDirectoryNames": [
   "folder1",
   "folder2"
 ]
```

### Terraform command options

You can configure the path to the Terraform binary used by terraform-ls to perform operations inside the editor by configuring this setting:

```json
"terraform.languageServer.terraform.path": "C:/some/folder/path"
```

You can override the Terraform execution timeout by configuring this setting:

```json
"terraform.languageServer.terraform.timeout": "30"
```

You can set the path Terraform logs (`TF_LOG_PATH`) by configuring this setting:

```json
"terraform.languageServer.terraform.logFilePath": "C:/some/folder/path/log-{{varname}}.log"
```

Supports variables (e.g. timestamp, pid, ppid) via Go template syntax `{{varname}}`

### Telemetry

We use telemetry to send error reports to our team, so we can respond more effectively. You can configure VS Code to send all telemetry, just crash telemetry, just errors or turn it off entirely by [configuring](https://code.visualstudio.com/docs/getstarted/telemetry#_disable-telemetry-reporting) `"telemetry.telemetryLevel"` to your desired value. You can also [monitor what's being sent](https://code.visualstudio.com/docs/getstarted/telemetry#_output-channel-for-telemetry-events) in your logs.

## Known Issues

- If there are syntax errors present in the document upon opening, intellisense may not provide all completions. Run `Terraform: validate` and fix validation errors, then reload the document and intellisense will work again. Potential solutions for this are being investigated in See [hcl-lang#57](https://github.com/hashicorp/hcl-lang/issues/57) for more information.
- Completion inside incomplete blocks, such as `resource "here` (without the closing quote and braces) is not supported. You can complete the 1st level blocks though and that will automatically trigger subsequent completion for e.g. resource types. See [terraform-ls#57](https://github.com/hashicorp/terraform-ls/issues/57) for more information.
- A number of different folder configurations (specifically when your root module is not a parent to any submodules) are not yet supported. More information available in ([terraform-ls#32](https://github.com/hashicorp/terraform-ls/issues/32#issuecomment-649707345))

### Terraform 0.11 compatibility

If you are using a Terraform version prior to 0.12.0, you can install the pre-transfer 1.4.0 version of this extension by following the instructions in the [pin version section](#pin-to-a-specific-version-of-the-extension).

The configuration has changed from 1.4.0 to v2.X. If you are having issues with the Language Server starting, you can reset the configuration to the following:

```json
"terraform.languageServer.enable": true,
"terraform.languageServer.args": ["serve"]
```

## Troubleshooting

- If you have a question about how to accomplish something with the extension, please ask on the [Terraform Editor Discuss site](https://discuss.hashicorp.com/c/terraform-core/terraform-editor-integrations/46)
- If you come across a problem with the extension, please file an [issue](https://github.com/hashicorp/vscode-terraform/issues/new/choose).
- If someone has already filed an issue that encompasses your feedback, please leave a 👍/👎 reaction on the issue
- Contributions are always welcome! Please see our [contributing guide](https://github.com/hashicorp/vscode-terraform/issues/new?assignees=&labels=enhancement&template=feature_request.md) for more details
- If you're interested in the development of the extension, you can read about our [development process](https://github.com/hashicorp/vscode-terraform/blob/HEAD/DEVELOPMENT.md)

### Settings Migration

Read more about [changes in settings options introduced in v2.24.0](https://github.com/hashicorp/vscode-terraform/blob/HEAD/docs/settings-migration.md).

### Generate a bug report

Experience a problem? You can have VS Code open a Github issue in our repo with all the information filled out for you. Open the Command Palette and invoke `Terraform: Generate Bug Report`. This will inspect the VS Code version, the Terraform extension version, the terraform-ls version and the list of installed extensions and open a browser window with GitHub loaded. You can then inspect the information provided, edit if desired, and submit the issue.

### Reload the extension

If you haven't seen the Problems Pane update in awhile, or hover and intellisense doesn't seem to showing up, you might not know what to do. Sometimes the Terraform extension can experience problems which cause the editor to not respond. The extension has a way of [reporting the problem](#generate-a-bug-report), but there is something you can do to get right back to working after reporting the problem: reload the Terraform extension.

You can reload the Terraform extension by opening the command palette and starting to type `Reload`. A list of commands will appear, select `Reload Window`. This will reload the Visual Studio Code window without closing down the entire editor, and without losing any work currently open in the editor.

### Pin to a specific version of the extension

If you wish to install a specific version of the extension, you can choose 'Install Another version' option in the Extensions pane. This will bring up a list of prior versions for the selected extension. Choose the version you want to install from the list.

![](https://github.com/hashicorp/vscode-terraform/raw/HEAD/docs/pin_version.png)

## Code of Conduct

HashiCorp Community Guidelines apply to you when interacting with the community here on GitHub and contributing code to this repository.

Please read the full text at https://www.hashicorp.com/community-guidelines

## Contributing

We are an open source project on GitHub and would enjoy your contributions! Consult our [development guide](https://github.com/hashicorp/vscode-terraform/blob/HEAD/DEVELOPMENT.md) for steps on how to get started. Please [open a new issue](https://github.com/hashicorp/vscode-terraform/issues) before working on a PR that requires significant effort. This will allow us to make sure the work is in line with the project's goals.

## Release History

**v2.0.0** is the first official release from HashiCorp, prior releases were by [Mikael Olenfalk](https://github.com/mauve).

The 2.0.0 release integrates a new [Language Server package from HashiCorp](https://github.com/hashicorp/terraform-ls). The extension will install and upgrade terraform-ls to continue to add new functionality around code completion and formatting. See the [terraform-ls CHANGELOG](https://github.com/hashicorp/terraform-ls/blob/main/CHANGELOG.md) for details.

In addition, this new version brings the syntax highlighting up to date with all HCL2 features, as needed for Terraform 0.12 and above.

> **Configuration Changes** Please note that in 2.x, the configuration differs from 1.4.0, see [Known Issues](#known-issues) for more information.

See the [CHANGELOG](https://github.com/hashicorp/vscode-terraform/blob/main/CHANGELOG.md) for more detailed release notes.

## Credits

- [Mikael Olenfalk](https://github.com/mauve) - creating and supporting the [vscode-terraform](https://github.com/mauve/vscode-terraform) extension, which was used as a starting point and inspiration for this extension.
