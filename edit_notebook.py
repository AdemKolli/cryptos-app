import json

with open('/vercel/sandbox/uploads/stacking_Pw.ipynb', 'r') as f:
    nb = json.load(f)

# The last cell is index 5
cell = nb['cells'][5]

new_source = [
    "# TODO: implémenter  les étapes 1 à 4\n",
    "from sklearn.metrics import accuracy_score, roc_auc_score\n",
    "\n",
    "def train_bases_and_predict_full(X_train, y_train, X_test, models, proba=True):\n",
    "    meta_X_test = np.zeros((X_test.shape[0], len(models)))\n",
    "    for i, (name, model) in enumerate(models):\n",
    "        model_clone = sklearn.base.clone(model)\n",
    "        model_clone.fit(X_train, y_train)\n",
    "        if proba:\n",
    "            preds = model_clone.predict_proba(X_test)[:, 1]\n",
    "        else:\n",
    "            preds = model_clone.predict(X_test)\n",
    "        meta_X_test[:, i] = preds\n",
    "    return meta_X_test\n",
    "\n",
    "# 1) Construire oof_X\n",
    "oof_X, fitted_full = build_oof_predictions(X_train, y_train, base_models, k=5, stratify=True, seed=1, proba=True)\n",
    "\n",
    "# 2) Entraîner meta_model sur oof_X\n",
    "meta_model.fit(oof_X, y_train)\n",
    "\n",
    "# 3) Préparer meta_X_test (entraîner chaque base sur tout X_train puis prédire sur X_test)\n",
    "meta_X_test = train_bases_and_predict_full(X_train, y_train, X_test, base_models, proba=True)\n",
    "\n",
    "# 4) Évaluer stacking vs baselines\n",
    "y_pred_meta = meta_model.predict(meta_X_test)\n",
    "print('Stacking acc:', accuracy_score(y_test, y_pred_meta))\n",
    "\n",
    "# Bonus: comparer avec les baselines individuels\n",
    "for name, model in fitted_full.items():\n",
    "    y_pred_base = model.predict(X_test)\n",
    "    acc = accuracy_score(y_test, y_pred_base)\n",
    "    print(f'{name} acc: {acc}')\n",
    "\n"
]

cell['source'] = new_source

with open('/vercel/sandbox/uploads/stacking_Pw.ipynb', 'w') as f:
    json.dump(nb, f, indent=1)