import babelParser from "@babel/eslint-parser";
import js from "@eslint/js";
import globals from "globals";

export default [
	js.configs.recommended,
	{
		languageOptions: {
			globals: {...globals.nodeBuiltin},
			parser: babelParser,
			parserOptions: {
				requireConfigFile: false,
				babelOptions: {
					babelrc: false,
					configFile: false,
					plugins: ["@babel/plugin-syntax-import-attributes"]
				}
			}
		},
		rules: {
			"array-callback-return": "error",
			"no-await-in-loop": "off",
			"no-constructor-return": "error",
			"no-duplicate-imports": "error",
			"no-inner-declarations": "error",
			"no-promise-executor-return": "error",
			"no-self-compare": "error",
			"no-template-curly-in-string": "error",
			"no-unmodified-loop-condition": "error",
			"no-unreachable-loop": "error",
			"no-use-before-define": ["error", {functions: false}],
			// "no-useless-assignment": "error",
			"require-atomic-updates": ["error", {allowProperties: true}],

			"accessor-pairs": "error",
			"arrow-body-style": "error",
			"block-scoped-var": "error",
			"camelcase": "off",
			"capitalized-comments": "error",
			"class-methods-use-this": "off",
			"complexity": ["error", {max: 50}],
			"consistent-return": "off",
			"consistent-this": "error",
			"curly": ["error", "multi"],
			"default-case": "error",
			"default-case-last": "error",
			"default-param-last": "error",
			"dot-notation": "error",
			"eqeqeq": "off",
			"func-name-matching": "error",
			"func-names": "off",
			"func-style": ["error", "declaration", {allowArrowFunctions: true}],
			"grouped-accessor-pairs": "error",
			"guard-for-in": "error",
			"id-denylist": "error",
			"id-length": ["error", {exceptions: ["_", "x", "y"]}],
			"id-match": "error",
			"init-declarations": "error",
			"logical-assignment-operators": "error",
			"max-classes-per-file": "off",
			"max-depth": "error",
			"max-lines": ["error", {max: 500}],
			"max-lines-per-function": ["error", {max: 100}],
			"max-nested-callbacks": "error",
			"max-params": "off",
			"max-statements": ["error", {max: 25}],
			"multiline-comment-style": ["error", "separate-lines"],
			"new-cap": ["error", {capIsNewExceptions: ["RangeError", "SyntaxError", "TypeError"]}],
			"no-alert": "error",
			"no-array-constructor": "error",
			"no-bitwise": "off",
			"no-caller": "error",
			"no-console": "off",
			"no-continue": "off",
			"no-div-regex": "error",
			"no-else-return": "error",
			"no-empty-function": "error",
			"no-eq-null": "off",
			"no-eval": "error",
			"no-extend-native": "error",
			"no-extra-bind": "error",
			"no-extra-label": "error",
			"no-implicit-coercion": "error",
			"no-implicit-globals": "error",
			"no-implied-eval": "error",
			"no-inline-comments": "off",
			"no-invalid-this": "error",
			"no-iterator": "error",
			"no-label-var": "error",
			"no-labels": "error",
			"no-lone-blocks": "error",
			"no-lonely-if": "error",
			"no-loop-func": "error",
			"no-magic-numbers": "off",
			"no-multi-assign": ["error", {ignoreNonDeclaration: true}],
			"no-multi-str": "error",
			"no-negated-condition": "off",
			"no-nested-ternary": "off",
			"no-new": "error",
			"no-new-func": "error",
			"no-new-wrappers": "error",
			"no-object-constructor": "error",
			"no-octal-escape": "error",
			"no-param-reassign": "off",
			"no-plusplus": "off",
			"no-proto": "error",
			"no-restricted-exports": "error",
			"no-restricted-globals": "error",
			"no-restricted-imports": "error",
			"no-restricted-properties": "error",
			"no-restricted-syntax": "error",
			"no-return-assign": "error",
			"no-script-url": "error",
			"no-sequences": "error",
			"no-shadow": "error",
			"no-ternary": "off",
			"no-throw-literal": "error",
			"no-undef-init": "error",
			"no-undefined": "error",
			"no-underscore-dangle": "error",
			"no-unneeded-ternary": "error",
			"no-unused-expressions": "error",
			"no-useless-call": "error",
			"no-useless-computed-key": "error",
			"no-useless-concat": "error",
			"no-useless-constructor": "error",
			"no-useless-rename": "error",
			"no-useless-return": "error",
			"no-void": ["error", {allowAsStatement: true}],
			"no-warning-comments": "warn",
			"object-shorthand": "error",
			"one-var": ["error", "never"],
			"operator-assignment": "error",
			"prefer-arrow-callback": "error",
			"prefer-const": "error",
			"prefer-destructuring": "error",
			"prefer-exponentiation-operator": "error",
			"prefer-named-capture-group": "off",
			"prefer-numeric-literals": "error",
			"prefer-object-has-own": "error",
			"prefer-object-spread": "error",
			"prefer-promise-reject-errors": "error",
			"prefer-regex-literals": "error",
			"prefer-rest-params": "error",
			"prefer-spread": "error",
			"prefer-template": "error",
			"radix": ["error", "as-needed"],
			"require-await": "error",
			"require-unicode-regexp": "off",
			"sort-imports": "off",
			"sort-keys": "off",
			"sort-vars": "error",
			"strict": ["error", "global"],
			"symbol-description": "error",
			"vars-on-top": "error",
			"yoda": "error",

			"line-comment-position": "error",
			"unicode-bom": "error"
		}
	}
];
