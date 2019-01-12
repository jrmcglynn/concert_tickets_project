%cd Analysis/
!pwd

import importlib
import connection_class
_ = importlib.reload(connection_class)

dataaa = connection_class.Ticket_PredictionData()

X, X_h, y, y_h = dataaa.get_data(max_events=100, max_perf=100, max_zones=100)

print(X.shape, X_h.shape, y.shape, y_h.shape)

X.shape

X.head()

X.columns

y.shape

y.head()

y.mean()


from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier()
rf.fit(X, y)

rf.score(X, y)

pd.Series(rf.predict(X)).value_counts()
